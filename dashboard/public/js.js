const login = document.getElementById("login-template")
var userRenderer = Handlebars.compile(login.innerHTML)
login.insertAdjacentHTML("beforebegin", userRenderer(DATA.user))

let path = window.location.href
let active = document.getElementById("nav").querySelector("a[href=\""+ path.substr(path.lastIndexOf("/")) + "\"]")

active.parentElement.classList.add("active")
active.href = "#"