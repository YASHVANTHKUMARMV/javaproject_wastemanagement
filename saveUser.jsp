<%@ page import="java.sql.*" %>

<html>
<head>

<style>

    body{
        margin:0;
        padding:0;
        font-family:Arial;
        background:linear-gradient(to right,#43e97b,#38f9d7);
        height:100vh;
        display:flex;
        justify-content:center;
        align-items:center;
    }

    .message-box{
        background:white;
        padding:40px;
        border-radius:15px;
        box-shadow:0px 0px 20px rgba(0,0,0,0.3);
        text-align:center;
    }

    h2{
        color:green;
    }

    a{
        text-decoration:none;
        color:white;
        background:#4facfe;
        padding:10px 20px;
        border-radius:8px;
    }

</style>

</head>

<body>

<div class="message-box">

<%

String id = request.getParameter("id");
String name = request.getParameter("name");

Connection con = null;
PreparedStatement ps = null;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/studentdb",
        "root",
        "Yash#2012"
    );

    String query = "INSERT INTO users(id,name) VALUES(?,?)";

    ps = con.prepareStatement(query);

    ps.setInt(1,Integer.parseInt(id));
    ps.setString(2,name);

    int result = ps.executeUpdate();

    if(result > 0){

%>

        <h2>✅ Data Inserted Successfully</h2>

        <p>
            Welcome,
            <b><%= name %></b>
        </p>

        <br>

        <a href="index.html">Add Another User</a>

<%

    }
    else{

%>

        <h2>❌ Insertion Failed</h2>

<%

    }

}
catch(Exception e){

%>

    <h2>Error:</h2>

    <p><%= e %></p>

<%

}
finally{

    if(ps!=null)
        ps.close();

    if(con!=null)
        con.close();
}

%>

</div>

</body>
</html>