<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String status = request.getParameter("statusValue");
    if (status == null) status = "";
    String css = "status-draft";
    String label = status;
    switch (status) {
        case "Draft": css = "status-draft"; label = "Bản nháp"; break;
        case "Pending": css = "status-pending"; label = "Chờ duyệt"; break;
        case "Approved": css = "status-approved"; label = "Đã duyệt"; break;
        case "Rejected": css = "status-rejected"; label = "Từ chối"; break;
    }
%>
<span class="status-badge <%= css %>"><%= label %></span>
