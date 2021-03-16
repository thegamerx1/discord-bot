const login = document.getElementById("login-template")
var userRenderer = Handlebars.compile(login.innerHTML)
login.insertAdjacentHTML("beforebegin", userRenderer(DATA.user))