// DOM manipulation
// console.log(document.getElementById("title"));
// console.log(document instanceof HTMLDocument);
function sayHello (event) {
  console.log(event);
  if (event.shiftKey) {
    this.textContent = "Said it!";
  }
  var name =
   document.getElementById("name").value;
   var message = "<h2>Hello " + name + "!</h2>";

  // document
  //   .getElementById("content")
  //   .textContent = message;

  document
    .getElementById("content")
    .innerHTML = message;

  if (name === "student") {
    var title = 
      document
        .querySelector("#title")
        .textContent;
    title += " & Lovin' it!";
    document
        .querySelector("h1")
        .innerHTML = "<span style='color:red'>" + title + "</span>";
  }
}

function loaded(event) {
  document.querySelector("button").onclick = sayHello;
  document.querySelector("body").onmousemove = function (event) {
    if (event.shiftKey) {
      console.log("X: " + event.clientX);
      console.log("Y: " + event.clientY);  
    }
  }
}

document.addEventListener("DOMContentLoaded", loaded);