import urllib.request
import urllib.parse
import http.cookiejar
import re
import sys
import random

BASE_URL = "http://localhost:8080/Userwebapps/"

def run_test():
    # Set up cookie handler for session persistence
    cj = http.cookiejar.CookieJar()
    opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))
    urllib.request.install_opener(opener)

    print("Step 1: Fetching home page...")
    try:
        response = urllib.request.urlopen(BASE_URL)
        html = response.read().decode('utf-8')
        if "Smart Waste Monitoring System" in html or "Login" in html:
            print("  [SUCCESS] Home page loaded successfully.")
        else:
            print("  [FAILED] Home page did not contain expected text.")
            return False
    except Exception as e:
        print(f"  [ERROR] Cannot connect to server: {e}")
        return False

    # Generate a unique email for testing
    rand_id = random.randint(1000, 9999)
    citizen_name = f"Test Citizen {rand_id}"
    citizen_email = f"citizen{rand_id}@example.com"
    citizen_pwd = "password123"

    print(f"Step 2: Registering new citizen ({citizen_email})...")
    reg_data = urllib.parse.urlencode({
        'name': citizen_name,
        'email': citizen_email,
        'password': citizen_pwd,
        'confirmPassword': citizen_pwd,
        'role': 'CITIZEN',
        'ward': 'Ward 1 - Central',
        'address': '123 Test Street'
    }).encode('utf-8')

    try:
        req = urllib.request.Request(BASE_URL + "register", data=reg_data, method='POST')
        response = urllib.request.urlopen(req)
        resp_html = response.read().decode('utf-8')
        if "successful" in resp_html or "Login" in resp_html:
            print("  [SUCCESS] Registration completed.")
        else:
            print("  [FAILED] Registration response did not indicate success.")
            return False
    except Exception as e:
        print(f"  [ERROR] Registration failed: {e}")
        return False

    print("Step 3: Logging in as the new citizen...")
    login_data = urllib.parse.urlencode({
        'email': citizen_email,
        'password': citizen_pwd,
        'role': 'CITIZEN'
    }).encode('utf-8')

    qr_code = None
    try:
        req = urllib.request.Request(BASE_URL + "login", data=login_data, method='POST')
        response = urllib.request.urlopen(req)
        resp_html = response.read().decode('utf-8')
        if "Citizen Dashboard" in resp_html:
            print("  [SUCCESS] Citizen logged in and dashboard loaded.")
            # Search for the generated QR Code
            match = re.search(r'CITIZEN-[0-9A-F]+', resp_html)
            if match:
                qr_code = match.group(0)
                print(f"  [SUCCESS] Extracted Citizen QR Code: {qr_code}")
            else:
                print("  [FAILED] Could not extract QR code from dashboard.")
                return False
        else:
            print("  [FAILED] Citizen login did not redirect to citizen dashboard.")
            return False
    except Exception as e:
        print(f"  [ERROR] Citizen login failed: {e}")
        return False

    # Logout citizen
    try:
        urllib.request.urlopen(BASE_URL + "logout")
        print("Logged out citizen.")
    except Exception as e:
        print(f"Error logging out citizen: {e}")

    # Now login as worker
    print("Step 4: Logging in as Sanitation Worker...")
    worker_login_data = urllib.parse.urlencode({
        'email': 'worker@example.com',
        'password': 'worker123',
        'role': 'WORKER'
    }).encode('utf-8')

    try:
        cj.clear() # Clear cookies to start a new session
        req = urllib.request.Request(BASE_URL + "login", data=worker_login_data, method='POST')
        response = urllib.request.urlopen(req)
        resp_html = response.read().decode('utf-8')
        if "Worker Dashboard" in resp_html:
            print("  [SUCCESS] Worker logged in successfully.")
        else:
            print("  [FAILED] Worker login failed.")
            return False
    except Exception as e:
        print(f"  [ERROR] Worker login failed: {e}")
        return False

    print("Step 5: Worker records a low-segregation collection session (organic=1.0, dry=1.0, reject=8.0)...")
    collect_data = urllib.parse.urlencode({
        'citizenLookup': qr_code,
        'organicWeight': '1.0',
        'dryWeight': '1.0',
        'rejectWeight': '8.0',
        'rewardType': 'UPI Voucher',
        'notes': 'Test auto-complaint flow'
    }).encode('utf-8')

    try:
        req = urllib.request.Request(BASE_URL + "collect", data=collect_data, method='POST')
        response = urllib.request.urlopen(req)
        resp_html = response.read().decode('utf-8')
        if "warning" in resp_html.lower() or "complaint" in resp_html.lower() or "alert" in resp_html.lower() or "success" in resp_html.lower():
            print("  [SUCCESS] Automated low segregation warning displayed.")
        else:
            print("  [FAILED] Response did not indicate correct recording.")
            return False
    except Exception as e:
        print(f"  [ERROR] Collection recording failed: {e}")
        return False

    # Logout worker
    try:
        urllib.request.urlopen(BASE_URL + "logout")
        print("Logged out worker.")
    except Exception as e:
        print(f"Error logging out worker: {e}")

    # Login as citizen again to redeem points
    print("Step 6: Login as Citizen again to check points and request redemption...")
    try:
        cj.clear()
        req = urllib.request.Request(BASE_URL + "login", data=login_data, method='POST')
        response = urllib.request.urlopen(req)
        resp_html = response.read().decode('utf-8')
        if "Citizen Dashboard" in resp_html:
            points_match = re.search(r'<h3>⭐ Points Balance</h3>\s*<p class="stat-value">(\d+)</p>', resp_html)
            if points_match:
                points = int(points_match.group(1))
                print(f"  [SUCCESS] Available Citizen points: {points}")
            else:
                print("  [FAILED] Could not read points balance.")
                return False
        else:
            print("  [FAILED] Citizen login failed.")
            return False
    except Exception as e:
        print(f"  [ERROR] Login failed: {e}")
        return False

    print("Step 7: Requesting redemption of 2 points...")
    redeem_data = urllib.parse.urlencode({
        'rewardType': 'UPI Voucher',
        'pointsRequested': '2'
    }).encode('utf-8')

    try:
        req = urllib.request.Request(BASE_URL + "redeem", data=redeem_data, method='POST')
        response = urllib.request.urlopen(req)
        resp_html = response.read().decode('utf-8')
        if "submitted" in resp_html or "success" in resp_html.lower():
            print("  [SUCCESS] Redemption request succeeded.")
        else:
            print("  [FAILED] Redemption request failed.")
            return False
    except Exception as e:
        print(f"  [ERROR] Redemption post failed: {e}")
        return False

    # Logout citizen
    try:
        urllib.request.urlopen(BASE_URL + "logout")
        print("Logged out citizen.")
    except Exception as e:
        print(f"Error logging out citizen: {e}")

    # Login as admin to check complaints
    print("Step 8: Login as Admin to check and resolve the low segregation complaint...")
    admin_login_data = urllib.parse.urlencode({
        'email': 'admin@example.com',
        'password': 'admin123',
        'role': 'ADMIN'
    }).encode('utf-8')

    try:
        cj.clear()
        req = urllib.request.Request(BASE_URL + "login", data=admin_login_data, method='POST')
        response = urllib.request.urlopen(req)
        resp_html = response.read().decode('utf-8')
        if "Admin Dashboard" in resp_html:
            print("  [SUCCESS] Admin logged in successfully.")
        else:
            print("  [FAILED] Admin login failed.")
            return False
    except Exception as e:
        print(f"  [ERROR] Admin login failed: {e}")
        return False

    # Fetch complaints page to find complaint ID
    try:
        response = urllib.request.urlopen(BASE_URL + "complaints.jsp")
        resp_html = response.read().decode('utf-8')
        if "LOW_SEGREGATION" in resp_html:
            print("  [SUCCESS] Low segregation complaint visible in admin complaints list.")
            id_match = re.search(r'<input type="hidden" name="complaintId" value="(\d+)">', resp_html)
            if id_match:
                complaint_id = id_match.group(1)
                print(f"  [SUCCESS] Extracted Complaint ID: {complaint_id}")
                
                # Resolve the complaint
                print("Step 9: Resolving complaint...")
                resolve_data = urllib.parse.urlencode({
                    'complaintId': complaint_id,
                    'status': 'RESOLVED',
                    'adminNotes': 'Citizen warned about correct segregation bins'
                }).encode('utf-8')
                
                req = urllib.request.Request(BASE_URL + "resolveComplaint", data=resolve_data, method='POST')
                response = urllib.request.urlopen(req)
                resp_html2 = response.read().decode('utf-8')
                if "resolved" in resp_html2.lower() or "success" in resp_html2.lower():
                    print("  [SUCCESS] Complaint resolved successfully by Admin.")
                else:
                    print("  [FAILED] Could not resolve complaint.")
                    return False
            else:
                print("  [FAILED] Could not extract complaint ID from complaints page.")
                return False
        else:
            print("  [FAILED] Low segregation complaint not found in complaints page.")
            return False
    except Exception as e:
        print(f"  [ERROR] Admin complaints handling failed: {e}")
        return False

    # Step 10: Admin checks and processes redemptions
    print("Step 10: Admin checks the pending redemption requests...")
    try:
        response = urllib.request.urlopen(BASE_URL + "adminRedemptions.jsp")
        resp_html = response.read().decode('utf-8')
        if "PENDING" in resp_html:
            print("  [SUCCESS] Pending redemption request is visible to Admin.")
            id_match = re.search(r'<input type="hidden" name="redemptionId" value="(\d+)">', resp_html)
            if id_match:
                redemption_id = id_match.group(1)
                print(f"  [SUCCESS] Extracted Redemption ID: {redemption_id}")
                
                # Step 11: Reject the redemption to verify points refund
                print("Step 11: Admin rejects the redemption request to verify point refund...")
                reject_data = urllib.parse.urlencode({
                    'redemptionId': redemption_id,
                    'action': 'reject'
                }).encode('utf-8')
                
                req = urllib.request.Request(BASE_URL + "adminRedemptions", data=reject_data, method='POST')
                response = urllib.request.urlopen(req)
                resp_html2 = response.read().decode('utf-8')
                if "rejected" in resp_html2.lower() or "success" in resp_html2.lower():
                    print("  [SUCCESS] Redemption request rejected successfully by Admin.")
                else:
                    print("  [FAILED] Could not reject redemption request.")
                    return False
            else:
                print("  [FAILED] Could not extract redemption ID.")
                return False
        else:
            print("  [FAILED] No pending redemption requests found on admin page.")
            return False
    except Exception as e:
        print(f"  [ERROR] Admin redemption processing failed: {e}")
        return False

    # Logout admin
    try:
        urllib.request.urlopen(BASE_URL + "logout")
        print("Logged out admin.")
    except Exception as e:
        print(f"Error logging out admin: {e}")

    # Step 12: Citizen logs in again to verify refund
    print("Step 12: Citizen logs in to verify points were refunded...")
    try:
        cj.clear()
        req = urllib.request.Request(BASE_URL + "login", data=login_data, method='POST')
        response = urllib.request.urlopen(req)
        resp_html = response.read().decode('utf-8')
        if "Citizen Dashboard" in resp_html:
            points_match = re.search(r'<h3>⭐ Points Balance</h3>\s*<p class="stat-value">(\d+)</p>', resp_html)
            if points_match:
                points = int(points_match.group(1))
                print(f"  [SUCCESS] Available Citizen points (should be 6 after refund): {points}")
                if points != 6:
                    print("  [FAILED] Points were not refunded correctly.")
                    return False
            else:
                print("  [FAILED] Could not read points balance.")
                return False
        else:
            print("  [FAILED] Citizen login failed.")
            return False
    except Exception as e:
        print(f"  [ERROR] Citizen login failed: {e}")
        return False

    # Step 13: Request redemption of 3 points
    print("Step 13: Citizen requests another redemption of 3 points...")
    redeem_data2 = urllib.parse.urlencode({
        'rewardType': 'Public Transport Credits',
        'pointsRequested': '3'
    }).encode('utf-8')

    try:
        req = urllib.request.Request(BASE_URL + "redeem", data=redeem_data2, method='POST')
        response = urllib.request.urlopen(req)
        resp_html = response.read().decode('utf-8')
        if "submitted" in resp_html.lower() or "success" in resp_html.lower():
            print("  [SUCCESS] Second redemption request succeeded.")
        else:
            print("  [FAILED] Second redemption request failed.")
            return False
    except Exception as e:
        print(f"  [ERROR] Second redemption request failed: {e}")
        return False

    # Logout citizen
    try:
        urllib.request.urlopen(BASE_URL + "logout")
        print("Logged out citizen.")
    except Exception as e:
        print(f"Error logging out citizen: {e}")

    # Step 14: Admin logs in to approve the new redemption
    print("Step 14: Admin logs in to approve the new redemption request...")
    try:
        cj.clear()
        req = urllib.request.Request(BASE_URL + "login", data=admin_login_data, method='POST')
        response = urllib.request.urlopen(req)
        resp_html = response.read().decode('utf-8')
        if "Admin Dashboard" in resp_html:
            response = urllib.request.urlopen(BASE_URL + "adminRedemptions.jsp")
            resp_html = response.read().decode('utf-8')
            id_match = re.search(r'<input type="hidden" name="redemptionId" value="(\d+)">', resp_html)
            if id_match:
                redemption_id = id_match.group(1)
                print(f"  [SUCCESS] Extracted new Redemption ID: {redemption_id}")
                
                # Approve
                approve_data = urllib.parse.urlencode({
                    'redemptionId': redemption_id,
                    'action': 'approve'
                }).encode('utf-8')
                req = urllib.request.Request(BASE_URL + "adminRedemptions", data=approve_data, method='POST')
                response = urllib.request.urlopen(req)
                resp_html2 = response.read().decode('utf-8')
                if "approved" in resp_html2.lower() or "success" in resp_html2.lower():
                    print("  [SUCCESS] Redemption request approved successfully by Admin.")
                else:
                    print("  [FAILED] Could not approve redemption request.")
                    return False
            else:
                print("  [FAILED] Could not extract second redemption ID.")
                return False
        else:
            print("  [FAILED] Admin login failed.")
            return False
    except Exception as e:
        print(f"  [ERROR] Admin approval flow failed: {e}")
        return False

    # Logout admin
    try:
        urllib.request.urlopen(BASE_URL + "logout")
        print("Logged out admin.")
    except Exception as e:
        print(f"Error logging out admin: {e}")

    # Step 15: Citizen logs in to verify final status
    print("Step 15: Citizen logs in to verify approved redemption status...")
    try:
        cj.clear()
        req = urllib.request.Request(BASE_URL + "login", data=login_data, method='POST')
        response = urllib.request.urlopen(req)
        resp_html = response.read().decode('utf-8')
        if "Citizen Dashboard" in resp_html:
            points_match = re.search(r'<h3>⭐ Points Balance</h3>\s*<p class="stat-value">(\d+)</p>', resp_html)
            if points_match:
                points = int(points_match.group(1))
                print(f"  [SUCCESS] Available Citizen points (should be 3 after approval): {points}")
                if points != 3:
                    print("  [FAILED] Points balance is incorrect.")
                    return False
            else:
                print("  [FAILED] Could not read points balance.")
                return False
            
            if "APPROVED" in resp_html:
                print("  [SUCCESS] Redemption status 'APPROVED' is visible on citizen dashboard.")
            else:
                print("  [FAILED] Redemption status 'APPROVED' not visible on citizen dashboard.")
                return False
        else:
            print("  [FAILED] Citizen login failed.")
            return False
    except Exception as e:
        print(f"  [ERROR] Citizen login failed: {e}")
        return False

    print("\n[SUCCESS] ALL TESTS PASSED SUCCESSFULLY! The upgrade, point calculations, QR lookup, complaints, and redemption flows are fully operational.")
    return True

if __name__ == "__main__":
    success = run_test()
    sys.exit(0 if success else 1)
