# App's main client script
$ = require('jquery')
require('lib/fastclick')

exports.initialize = (config) ->
  touch = Modernizr.touch

  # Use the fastclick module for touch devices.
  # Add a class of `needsclick` of the original click
  # is needed.
  new FastClick(document.body)

  $mainNav = $('.main-nav')
  $mainNavIcon = $mainNav.find('> .icon')
  $mainNavList = $mainNav.find('> ul')
  
  $tocNav = $('.toc-nav')
  $tocNavIcon = $tocNav.find('> .icon')
  $tocNavList = $tocNav.find('> ul')
  
  $collectionNav = $('.collection-nav')
  $collectionNavIcon = $collectionNav.find('> .icon')
  $collectionNavList = $collectionNav.find('> ul')
  
  $article = $('.container > article')

  hidePopups = (exceptMe) ->
    $mainNavList.hide() unless $mainNavList is exceptMe
    $tocNavList.hide() unless $tocNavList is exceptMe
    $collectionNavList.hide() unless $collectionNavList is exceptMe

  $('html').on 'click', (e) ->
    hidePopups()
  
  # Setup the Main menu
  $mainNavIcon.on 'click', (e) ->
    e.stopPropagation()
    hidePopups($mainNavList)
    $mainNavList.toggle()

  # Setup the TOC menu
  if $tocNav and $article
    $article.find('h3').each ->
      heading = $(@)
      text = heading.text()
      headingId = 'TOC-' + text.replace(/[\ \.\?\#\'\"]/g, '-')
      heading.attr('id', headingId)
      $tocNavList.append "<li><a href=\"##{headingId}\">#{text}</a></li>"

    $tocNavIcon.on 'click', (e) ->
      e.stopPropagation()
      hidePopups($tocNavList)
      $tocNavList.toggle()

  # Setup the Collection menu
  if $collectionNav
    collectionId = $collectionNav.attr('data-id')
    collectionSlug = $collectionNav.attr('data-slug')
    if collectionSlug
      $.ajax
        type: 'GET'
        url: "/json/collection/#{collectionSlug}"
        contentType: 'json'
        success: (data) ->
          if data
            data = JSON.parse(data)
            for row in data.rows
              doc = row.doc
              url = "/#{doc.type}/#{doc.slug}"
              selectedClass = if window.location.pathname is url then 'active' else ''
              $collectionNavList.append "<li><a href=\"#{url}\" class=\"#{selectedClass}\">#{doc.title}</a></li>"

    $collectionNavIcon.on 'click', (e) ->
      e.stopPropagation()
      hidePopups($collectionNavList)
      $collectionNavList.toggle()
