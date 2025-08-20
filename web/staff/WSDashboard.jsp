<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Warehouse Dashboard</title>
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link rel="shortcut icon" href="<c:url value='/staff/img/icons/icon-48x48.png'/>" />
        <link rel="stylesheet" href="<c:url value='/staff/css/light.css'/>" class="js-stylesheet">
        <link href="<c:url value='/staff/css/light.css'/>" rel="stylesheet">
        <script src="<c:url value='/staff/js/settings.js'/>"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="<c:url value='/staff/js/app.js'/>"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                feather.replace();
            });
        </script>
        <style>
            /* Custom styles for WSDashboard.jsp */
            .card-flex {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 1rem;
            }

            .card-flex {
                display: flex;
                justify-content: space-between;
                align-items: center;

                .stat-icon {
                    background-color: #3b7ddd;
                    border-radius: 50%;
                    color: white;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    height: 60px;
                    width: 60px;
                    font-size: 28px;
                    box-shadow: 0 4px 8px rgba(59, 125, 221, 0.4);
                    transition: background-color 0.3s ease;
                }
                .stat-icon:hover {
                    background-color: #2f64b1;
                    box-shadow: 0 6px 12px rgba(47, 100, 177, 0.6);
                }

                .quick-action-card {
                    padding: 0.75rem;
                    margin-bottom: 1.5rem;
                }

                /* Status badges with distinct colors */
                .badge-status {
                    font-weight: 600;
                    font-size: 0.85rem;
                    padding: 0.4em 0.75em;
                    border-radius: 0.5rem;
                    color: #fff;
                    display: inline-block;
                    min-width: 90px;
                    text-align: center;
                    box-shadow: 0 2px 6px rgba(0,0,0,0.15);
                    transition: background-color 0.3s ease;
                }
                .badge-status.sale-order {
                    background-color: #28a745; /* green */
                }
                .badge-status.purchase-order {
                    background-color: #ffc107; /* amber */
                    color: #212529;
                }
                .badge-status.pending {
                    background-color: #17a2b8; /* info blue */
                }
                .badge-status.approved {
                    background-color: #1cbb8c; /* success teal */
                }
                .badge-status.unapproved {
                    background-color: #dc3545; /* danger red */
                }
                .badge-status.completed {
                    background-color: #6c757d; /* secondary gray */
                }
            </style>
        </head>
        <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
            <div class="wrapper">
                <jsp:include page="WsSidebar.jsp" />
                <div class="main">
                    <jsp:include page="navbar.jsp" />

                    <main class="content">
                    </main>

                    <jsp:include page="footer.jsp" />
                </div>
            </div>

            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    feather.replace();
                });
            </script>
        </body>
    </html>
