import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="likes"
export default class extends Controller {
  like(event) {
     let postId = event.target.dataset.likesPostIdValue
     fetch(`/posts/${postId}/likes`, {
        contentType: 'application/json',
        hearders: 'application/json'
      })
      .then((response) => response.json())
      .then(res => {
        event.target.innerHTML = res.liked ? 'Unlike' : 'Like'
        document.getElementById(`post_${postId}_likes_count`).innerHTML = res.total_likes
      }) 
  }
}
