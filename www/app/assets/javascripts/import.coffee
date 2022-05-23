# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->

$realInputField = $('#real_file')

$realInputField.change ->
$('#file-display').val $(@).val().replace(/^.*[\\\/]/, '')

$('#upload-btn').click ->
$realInputField.click()