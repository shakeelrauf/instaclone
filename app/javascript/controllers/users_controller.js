import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="users"
export default class extends Controller {
  follow(event) {
    debugger
    let userId = event.target.dataset.userIdValue
     fetch(`/users/${userId}/follow`, {
        contentType: 'application/json',
        hearders: 'application/json'
      })
      .then((response) => response.json())
      .then(res => {
        document.getElementById(`user-follow-${userId}`).innerHTML = 'Unfollow'
      }) 
  }
}
