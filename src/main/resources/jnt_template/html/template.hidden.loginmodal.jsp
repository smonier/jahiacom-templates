<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="sl" uri="http://jahia.com/jahiacom/taglibs" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>

<c:set var="sitekey" value="${renderContext.site.siteKey}"/>


<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="loginModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content rounded-0 border-primary border-left-0  border-right-0  border-bottom-0">
            <div class="modal-header">
                <h5 class="modal-title primary" id="loginModalLabel"><fmt:message key="label.login"/></h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">


                <c:catch var="errorForm">
                    <ui:loginArea id="loginForm">

                        <ui:isLoginError var="loginResult">
                            <div class="alert alert-danger alert-dismissible fade show">
                                <button type="button" class="close" data-dismiss="alert">&times;</button>
                                <i class="fas fa-exclamation-triangle fa-2x fa-pull-left"></i> <strong>Error: </strong>
                                <c:choose>
                                    <c:when test="${loginResult == 'account_locked'}">
                                        <fmt:message key="message.accountLocked"/>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:message key="message.invalidUsernamePassword"/>
                                    </c:otherwise>
                                </c:choose>
                                !
                            </div>
                            <script>
                                $('#loginModal').modal('show')
                            </script>
                        </ui:isLoginError>
                        <c:if test="${not empty param['loginError']}">
                            <div class="alert alert-danger alert-dismissible fade show">
                                <button type="button" class="close" data-dismiss="alert">&times;</button>
                                <i class="fas fa-exclamation-triangle fa-2x fa-pull-left"></i> <strong>Error: </strong>
                                <c:choose>
                                    <c:when test="${param['loginError'] == 'account_locked'}">
                                        <fmt:message key="message.accountLocked"/>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:message key="message.invalidUsernamePassword"/>
                                    </c:otherwise>
                                </c:choose>
                                !
                            </div>
                            <script>
                                $('#loginModal').modal('show')
                            </script>

                        </c:if>

                    <div class="form-group">
                        <c:set var="forgotPasswordPageNode" value="${renderContext.site.properties.forgotPasswordPage.node}"/>
                        <c:choose>
                            <c:when test="${! empty forgotPasswordPageNode}">
                                <c:url var="forgotPasswordPageUrl" value="${forgotPasswordPageNode.url}" context="/"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="forgotPasswordPageUrl" value="#"/>
                            </c:otherwise>
                        </c:choose>


                        <label for="username"><fmt:message key='label.username'/></label>
                        <input type="text" class="form-control form-control" name="username" id="username" placeholder="<fmt:message key='label.username'/>"/>
                    </div>
                    <div class="form-group">
                        <label for="password"><fmt:message key='label.password'/></label>
                        <input type="password" class="form-control form-control" name="password" id="password" placeholder="<fmt:message key='label.password'/>"/>
                    </div>
                    <div class="custom-control custom-checkbox">
                        <input type="checkbox" class="custom-control-input" id="useCookie">
                        <label class="custom-control-label" for="useCookie"><fmt:message key="label.rememberMe"/></label>
                    </div>
                    <div class="form-group pt-4 d-flex align-items-end justify-content-between">
                        <div>
                            <a href="${forgotPasswordPageUrl}" class="text-secondary float-left"><small><fmt:message key="label.forgotPassword"/></small></a>
                        </div>
                        <div>
                            <button class="btn btn-outline-dark float-right" data-dismiss="modal" aria-hidden="true"><fmt:message key="label.cancel"/></button>
                            <button type="submit" class="float-right mr-2 btn btn-primary" id="btnLogin"><fmt:message key="label.login"/></button>
                        </div>
                    </div>

                    </ui:loginArea>
                </c:catch>
                <c:if test = "${errorForm != null}">
                    <!--
                    <p>The exception is : ${errorForm} <br />
                        There is an exception (errorForm): ${errorForm.message}</p>
                    -->
                </c:if>

                <script>
                    $('#loginForm input').keypress(function (e) {
                        if (e.which == 13) {
                            console.log("char 13 found... submit form");
                            $('#loginForm').submit();
                            return false;
                        }
                    });
                </script>
            </div>
            <div class="modal-footer justify-content-center flex-column bg-gris mb-0">
                <c:set var="registerPageNode" value="${renderContext.site.properties.registerPage.node}"/>
                <c:choose>
                    <c:when test="${! empty registerPageNode}">
                        <c:url var="registerPageUrl" value="${registerPageNode.url}" context="/"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="registerPageUrl" value="#"/>
                    </c:otherwise>
                </c:choose>

                <div><small><fmt:message key="label.needAccount"/></small></div>
                <div><small><a href="${registerPageUrl}" class="text-center text-primary"><fmt:message key="label.newUser"/></a></small></div>
                <hr class="mt-3 mb-3"/>
                <div class="text-center text-muted delimiter">or use a social network</div>
                <div class="d-flex justify-content-center social-buttons">
                    <c:if test="${sl:validateSocialLogin('LinkedInApi20',sitekey)}">
                        <template:include view="hidden.sociallogin.linkedInButton"/>
                    </c:if>
                    <c:if test="${sl:validateSocialLogin('FacebookApi',sitekey)}">
                        <template:include view="hidden.sociallogin.facebookButton"/>
                    </c:if>
                    <c:if test="${sl:validateSocialLogin('GitHubApi',sitekey)}">
                        <template:include view="hidden.sociallogin.githubButton"/>
                    </c:if>
                    <c:if test="${sl:validateSocialLogin('GoogleApi20',sitekey)}">
                        <template:include view="hidden.sociallogin.googleButton"/>
                    </c:if>

                </div>
            </div>
        </div>
    </div>
</div>
