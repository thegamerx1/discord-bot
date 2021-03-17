const login = $("#login-template")
var userRenderer = Handlebars.compile(login.html())
$("#nav").append(userRenderer(DATA.user))

let path = window.location.href
let active = $("nav a[href=\""+ path.substr(path.lastIndexOf("/")) + "\"]")
active.parent().addClass("active")
active.href = "#"