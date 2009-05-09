// auto-fill the slug using input from the title
Event.observe(window, 'load', function() {
  $('post_title').observe('keyup', function(event) {
    slug = event.element().value;
    slug = slug.replace(/\s/g, '-').replace(/[^a-zA-Z0-9_-]/g, '');
    $('post_slug').value = slug;
  });
});