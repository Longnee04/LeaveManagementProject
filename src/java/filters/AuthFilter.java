package filters;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import models.User;
import utils.RoleConstants;
import utils.SessionKeys;

@WebFilter(urlPatterns = {"/admin/*", "/manager/*", "/employee/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute(SessionKeys.USER) : null;

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getRequestURI().substring(req.getContextPath().length());
        if (!RoleConstants.canAccess(user.getRoleName(), path)) {
            res.sendRedirect(req.getContextPath() + RoleConstants.homePath(user.getRoleName()));
            return;
        }

        chain.doFilter(request, response);
    }
}
