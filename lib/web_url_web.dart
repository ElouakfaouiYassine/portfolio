library web_url_web;
import 'dart:html' as html;

void setHash(String hash) {
  // sets "#<hash>"
  html.window.location.hash = hash.startsWith('#') ? hash : '#$hash';
}

void replaceHash(String hash) {
  // replaces the fragment without adding a history entry
  final frag = hash.isEmpty ? '' : (hash.startsWith('#') ? hash : '#$hash');
  html.window.history.replaceState(null, '', '${html.window.location.pathname}${html.window.location.search}$frag');
}

void clearHash() {
  replaceHash('');
}

String getHash() {
  final h = html.window.location.hash;
  return h.startsWith('#') ? h.substring(1) : h;
}