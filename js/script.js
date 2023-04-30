// Create a new XMLHttpRequest object
var xhr = new XMLHttpRequest();

// Define a callback function to handle the response
xhr.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
        // Insert the header HTML into the DOM
        document.getElementById("header").innerHTML = xhr.responseText;
    }
};

// Open a GET request for the header HTML file
xhr.open("GET", "header.html", true);

// Send the request
xhr.send();