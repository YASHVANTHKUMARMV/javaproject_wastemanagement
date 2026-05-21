<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.wastemanagement.util.Constants" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Record Collection - Smart Waste Monitoring System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <%
        Object userSession = session.getAttribute(Constants.SESSION_USER);
        String role = (String) session.getAttribute(Constants.SESSION_ROLE);
        if (userSession == null || !Constants.ROLE_WORKER.equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>

    <nav class="navbar">
        <div class="container">
            <div class="brand">♻️ Waste Monitor</div>
            <div class="nav-links">
                <a href="workerDashboard.jsp">Dashboard</a>
                <a href="collectionForm.jsp">Record Collection</a>
                <a href="logout">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <section class="content-section">
            <h1>Record Citizen Collection</h1>
            <p class="subtitle">Enter citizen QR or ID and record segregated waste weights</p>

            <%
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");
                String warning = (String) request.getAttribute("warning");
                if (error != null) {
            %>
                <div class="alert alert-danger"><%= error %></div>
            <%
                }
                if (success != null) {
            %>
                <div class="alert alert-success"><%= success %></div>
            <%
                }
                if (warning != null) {
            %>
                <div class="alert alert-warning"><%= warning %></div>
            <%
                }
            %>

            <form action="collect" method="POST" class="form-grid">
                <div class="form-group">
                    <label for="citizenLookup">Citizen QR Code or ID:</label>
                    <div style="display: flex; gap: 10px; align-items: stretch;">
                        <input type="text" id="citizenLookup" name="citizenLookup" required placeholder="Enter QR code (e.g. CITIZEN-...) or DB User ID" style="flex: 1; margin-bottom: 0;">
                        <button type="button" id="btnConnect" class="btn btn-secondary" style="padding: 0 20px; border-radius: 10px; font-size: 0.95rem; display: flex; align-items: center; justify-content: center; white-space: nowrap; height: 100%;">
                            🔗 Connect
                        </button>
                    </div>
                    <!-- Live Connection Status Card -->
                    <div id="citizenConnectionStatus" style="margin-top: 15px; display: none;">
                        <div id="statusCard" style="border-radius: 12px; padding: 15px; border-left: 5px solid; font-size: 0.95rem; display: flex; flex-direction: column; gap: 8px; transition: all 0.3s ease;">
                            <div style="display: flex; align-items: center; justify-content: space-between; font-weight: 600;">
                                <span id="statusIndicator">🔄 Connecting...</span>
                                <span id="statusBadge" style="font-size: 0.75rem; padding: 2px 8px; border-radius: 20px; text-transform: uppercase;"></span>
                            </div>
                            <div id="citizenDetails" style="display: none; flex-direction: column; gap: 6px; border-top: 1px solid rgba(0,0,0,0.08); padding-top: 8px; margin-top: 4px;">
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: #6b7280;">Name:</span>
                                    <strong id="citizenName" style="color: #111827;"></strong>
                                </div>
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: #6b7280;">Ward/City:</span>
                                    <span id="citizenWard" style="color: #374151; font-weight: 500;"></span>
                                </div>
                                <div style="display: flex; justify-content: space-between;">
                                    <span style="color: #6b7280;">Address:</span>
                                    <span id="citizenAddress" style="color: #374151; font-weight: 500; text-align: right; max-width: 70%;"></span>
                                </div>
                                <div style="display: flex; justify-content: space-between; border-top: 1px dashed rgba(0,0,0,0.08); padding-top: 6px; margin-top: 2px;">
                                    <span style="color: #6b7280;">Current Reward Balance:</span>
                                    <strong id="citizenPoints" style="color: var(--primary);"></strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="organicWeight">Organic / Wet Weight (kg):</label>
                    <input type="number" id="organicWeight" name="organicWeight" step="0.1" min="0" required>
                </div>

                <div class="form-group">
                    <label for="dryWeight">Dry / Recyclable Weight (kg):</label>
                    <input type="number" id="dryWeight" name="dryWeight" step="0.1" min="0" required>
                </div>

                <div class="form-group">
                    <label for="rejectWeight">Reject / Non-Recyclable Weight (kg):</label>
                    <input type="number" id="rejectWeight" name="rejectWeight" step="0.1" min="0" required>
                </div>

                <div class="form-group">
                    <label for="rewardType">Reward Type:</label>
                    <select id="rewardType" name="rewardType" required>
                        <option value="">-- Select Reward Type --</option>
                        <option value="UPI Voucher">UPI Voucher</option>
                        <option value="Public Transport Credit">Public Transport Credit</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="notes">Notes (optional):</label>
                    <textarea id="notes" name="notes" rows="3" placeholder="Location, remarks, or citizen details..."></textarea>
                </div>

                <button type="submit" class="btn btn-primary btn-block">Submit Collection</button>
            </form>
        </section>
    </div>

    <!-- Conveyor Belt Sorting Overlay -->
    <div id="sortingOverlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.95); backdrop-filter: blur(10px); z-index: 9999; align-items: center; justify-content: center; color: white;">
        <div style="background: #1e1b4b; border: 1px solid rgba(255,255,255,0.1); border-radius: 20px; padding: 30px; max-width: 600px; width: 90%; text-align: center; box-shadow: 0 20px 50px rgba(0,0,0,0.5);">
            <h2 style="margin-bottom: 10px; font-weight: 700; color: #a5b4fc;">♻️ AI Conveyor Sorting Active</h2>
            <p style="color: #cbd5e1; font-size: 0.95rem; margin-bottom: 25px;">Processing waste segregation and scanning weights...</p>
            
            <div style="position: relative; height: 150px; background: #0f172a; border-radius: 12px; overflow: hidden; margin-bottom: 25px; border: 1px solid rgba(255,255,255,0.1);">
                <!-- Animated Conveyor Belt -->
                <div style="position: absolute; bottom: 35px; left: 0; width: 200%; height: 15px; background: repeating-linear-gradient(90deg, #475569, #475569 10px, #1e293b 10px, #1e293b 20px); animation: moveBelt 1s infinite linear; z-index: 1;"></div>
                
                <!-- Target Bins -->
                <div style="position: absolute; bottom: 5px; right: 15px; display: flex; gap: 15px; z-index: 2;">
                    <div style="display: flex; flex-direction: column; align-items: center;">
                        <span style="font-size: 1.8rem; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.5));">🟢</span>
                        <span style="font-size: 0.75rem; color: #4ade80; font-weight: 600; margin-top: 2px;">Wet</span>
                    </div>
                    <div style="display: flex; flex-direction: column; align-items: center;">
                        <span style="font-size: 1.8rem; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.5));">🔵</span>
                        <span style="font-size: 0.75rem; color: #60a5fa; font-weight: 600; margin-top: 2px;">Dry</span>
                    </div>
                    <div style="display: flex; flex-direction: column; align-items: center;">
                        <span style="font-size: 1.8rem; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.5));">🔴</span>
                        <span style="font-size: 0.75rem; color: #f87171; font-weight: 600; margin-top: 2px;">Reject</span>
                    </div>
                </div>

                <div id="itemsContainer"></div>
            </div>

            <!-- Accuracy Display -->
            <div style="margin-bottom: 20px;">
                <div style="font-size: 0.85rem; color: #94a3b8; text-transform: uppercase; letter-spacing: 1.5px; margin-bottom: 5px;">Segregation Accuracy</div>
                <div id="accuracyCounter" style="font-size: 3.5rem; font-weight: 800; color: #4ade80; text-shadow: 0 0 15px rgba(74,222,128,0.3);">0.0%</div>
            </div>

            <!-- Status Indicator -->
            <div id="sortingStatus" style="font-style: italic; color: #a5b4fc; min-height: 24px; font-weight: 500;">Initializing conveyor belt...</div>
        </div>
    </div>

    <style>
        @keyframes moveBelt {
            0% { transform: translateX(0); }
            100% { transform: translateX(-20px); }
        }
    </style>

    <script>
        // Global citizen verification state
        window.isCitizenValid = false;

        document.addEventListener("DOMContentLoaded", function() {
            var citizenInput = document.getElementById("citizenLookup");
            var connectBtn = document.getElementById("btnConnect");
            var statusContainer = document.getElementById("citizenConnectionStatus");
            var statusCard = document.getElementById("statusCard");
            var statusIndicator = document.getElementById("statusIndicator");
            var statusBadge = document.getElementById("statusBadge");
            var citizenDetails = document.getElementById("citizenDetails");
            
            var citizenName = document.getElementById("citizenName");
            var citizenWard = document.getElementById("citizenWard");
            var citizenAddress = document.getElementById("citizenAddress");
            var citizenPoints = document.getElementById("citizenPoints");
            
            var debounceTimeout = null;

            function verifyCitizen() {
                var val = citizenInput.value.trim();
                if (!val) {
                    statusContainer.style.display = "none";
                    window.isCitizenValid = false;
                    return;
                }

                // Show connecting state
                statusContainer.style.display = "block";
                statusCard.style.background = "#f3f4f6";
                statusCard.style.color = "#4b5563";
                statusCard.style.borderColor = "#9ca3af";
                statusIndicator.innerHTML = "🔄 Querying MySQL Database...";
                statusBadge.innerText = "Connecting";
                statusBadge.style.background = "#e5e7eb";
                statusBadge.style.color = "#4b5563";
                citizenDetails.style.display = "none";

                fetch("collect?lookup=" + encodeURIComponent(val))
                    .then(function(res) {
                        return res.json();
                    })
                    .then(function(data) {
                        if (data.success) {
                            window.isCitizenValid = true;
                            // Show success card
                            statusCard.style.background = "#ecfdf5";
                            statusCard.style.color = "#065f46";
                            statusCard.style.borderColor = "var(--success)";
                            statusIndicator.innerHTML = "🟢 Connected in Real-Time";
                            statusBadge.innerText = "Live";
                            statusBadge.style.background = "#d1fae5";
                            statusBadge.style.color = "#065f46";
                            
                            citizenName.innerText = data.name;
                            citizenWard.innerText = data.ward;
                            citizenAddress.innerText = data.address;
                            citizenPoints.innerText = data.points + " pts";
                            citizenDetails.style.display = "flex";
                        } else {
                            window.isCitizenValid = false;
                            // Show error card
                            statusCard.style.background = "#fef2f2";
                            statusCard.style.color = "#991b1b";
                            statusCard.style.borderColor = "var(--danger)";
                            statusIndicator.innerHTML = "🔴 Citizen Not Found";
                            statusBadge.innerText = "Offline";
                            statusBadge.style.background = "#fee2e2";
                            statusBadge.style.color = "#991b1b";
                            citizenDetails.style.display = "none";
                        }
                    })
                    .catch(function(err) {
                        window.isCitizenValid = false;
                        statusCard.style.background = "#fffbeb";
                        statusCard.style.color = "#92400e";
                        statusCard.style.borderColor = "var(--warning)";
                        statusIndicator.innerHTML = "⚠️ Connection Error";
                        statusBadge.innerText = "Error";
                        statusBadge.style.background = "#fef3c7";
                        statusBadge.style.color = "#92400e";
                        citizenDetails.style.display = "none";
                    });
            }

            // Debounced lookup
            citizenInput.addEventListener("input", function() {
                clearTimeout(debounceTimeout);
                debounceTimeout = setTimeout(verifyCitizen, 600);
            });

            // Connect button click
            connectBtn.addEventListener("click", function() {
                clearTimeout(debounceTimeout);
                verifyCitizen();
            });

            // Run verification initially if input has value (e.g. redirected or autofilled)
            if (citizenInput.value.trim()) {
                verifyCitizen();
            }
        });

        document.querySelector("form").addEventListener("submit", function(e) {
            e.preventDefault();

            // Prevent form submit if citizen is not valid
            if (!window.isCitizenValid) {
                alert("Please enter a valid Citizen QR Code or ID and connect before submitting.");
                return;
            }

            var form = this;

            var organic = parseFloat(document.getElementById("organicWeight").value) || 0;
            var dry = parseFloat(document.getElementById("dryWeight").value) || 0;
            var reject = parseFloat(document.getElementById("rejectWeight").value) || 0;
            var total = organic + dry + reject;
            
            if (total <= 0) {
                alert("Please enter a positive weight for at least one category.");
                return;
            }

            var targetAccuracy = total > 0 ? (((organic + dry) / total) * 100) : 0;

            // Show overlay
            var overlay = document.getElementById("sortingOverlay");
            overlay.style.display = "flex";

            // Setup counter & item paths
            var currentAccuracy = 0;
            var counterEl = document.getElementById("accuracyCounter");
            var statusEl = document.getElementById("sortingStatus");
            var itemsContainer = document.getElementById("itemsContainer");
            
            var wasteItems = [];
            if (organic > 0) {
                wasteItems.push({ emoji: "🍏", type: "organic" });
                wasteItems.push({ emoji: "🍌", type: "organic" });
            }
            if (dry > 0) {
                wasteItems.push({ emoji: "🧴", type: "dry" });
                wasteItems.push({ emoji: "🥫", type: "dry" });
            }
            if (reject > 0) {
                wasteItems.push({ emoji: "🔋", type: "reject" });
                wasteItems.push({ emoji: "🧻", type: "reject" });
            }
            
            // Fallback item
            if (wasteItems.length === 0) {
                wasteItems.push({ emoji: "📦", type: "dry" });
            }

            var totalDuration = 4000;
            var startTime = performance.now();

            function animate(now) {
                var elapsed = now - startTime;
                var progress = Math.min(elapsed / totalDuration, 1);

                // Count up accuracy
                currentAccuracy = progress * targetAccuracy;
                counterEl.innerText = currentAccuracy.toFixed(1) + "%";

                // Update text statuses
                if (progress < 0.25) {
                    statusEl.innerText = "Scanning items on conveyor belt...";
                } else if (progress < 0.5) {
                    statusEl.innerText = "Separating compostable organic waste...";
                } else if (progress < 0.75) {
                    statusEl.innerText = "Routing recyclables to clean dry bins...";
                } else if (progress < 0.9) {
                    statusEl.innerText = "Sorting reject residues...";
                } else {
                    statusEl.innerText = "Finalizing accuracy calculations...";
                }

                if (progress < 1) {
                    requestAnimationFrame(animate);
                } else {
                    counterEl.innerText = targetAccuracy.toFixed(1) + "%";
                    statusEl.innerText = "Sorting complete! Submitting collection data...";
                    setTimeout(function() {
                        form.submit();
                    }, 500);
                }
            }

            // Spawn animated items
            wasteItems.forEach(function(item, idx) {
                setTimeout(function() {
                    var el = document.createElement("div");
                    el.innerText = item.emoji;
                    el.style.position = "absolute";
                    el.style.fontSize = "26px";
                    el.style.zIndex = "5";
                    
                    var shift = 0; // dry (middle)
                    if (item.type === "organic") shift = -40; // wet (leftmost of bins)
                    if (item.type === "reject") shift = 40;  // reject (rightmost of bins)
                    
                    // Create dynamic animation path for this item
                    var styleId = "travelStyle_" + idx;
                    var styleEl = document.createElement("style");
                    styleEl.id = styleId;
                    styleEl.innerHTML = `@keyframes itemTravel_${idx} {
                        0% { left: 0%; top: 60px; opacity: 1; transform: scale(1); }
                        70% { left: calc(75% + ${shift}px); top: 60px; opacity: 1; transform: scale(1) rotate(0); }
                        90% { left: calc(82% + ${shift}px); top: 85px; opacity: 1; transform: scale(0.9) rotate(90deg); }
                        100% { left: calc(82% + ${shift}px); top: 120px; opacity: 0; transform: scale(0.1) rotate(180deg); }
                    }`;
                    document.head.appendChild(styleEl);
                    el.style.animation = `itemTravel_${idx} 1.5s forwards linear`;

                    itemsContainer.appendChild(el);
                    
                    // Clean style/node
                    setTimeout(function() {
                        el.remove();
                        styleEl.remove();
                    }, 1600);
                }, idx * 550);
            });

            requestAnimationFrame(animate);
        });
    </script>

    <footer class="footer">
        <p>&copy; 2026 Smart Waste Monitoring System. All rights reserved.</p>
    </footer>
</body>
</html>
