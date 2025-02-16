// Include the KaTeX library
const script = document.createElement('script');
script.src = 'https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.js';
const autoRenderScript = document.createElement('script');
autoRenderScript.src = 'https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/contrib/auto-render.min.js';
document.head.appendChild(autoRenderScript);

// script.onload = function() {
//   renderMathInElement(document.body, {
//     delimiters: [
//       {left: "$$", right: "$$", display: true},
//       {left: "$", right: "$", display: false}
//     ]
//   });
// };
// document.head.appendChild(script);

// window.onload = function () {
//     renderMathInElement(document.body, {
//       delimiters: [
//         {left: "$$", right: "$$", display: true},
//         {left: "$", right: "$", display: false}
//       ]
//     });
//   };
  
//   window.onhashchange = function () {
//     renderMathInElement(document.body, {
//       delimiters: [
//         {left: "$$", right: "$$", display: true},
//         {left: "$", right: "$", display: false}
//       ]
//     });
//   };
document.addEventListener("DOMContentLoaded", function() {
  renderMathInElement(document.body, {
    delimiters: [
      {left: "$$", right: "$$", display: true},
      {left: "\\[", right: "\\]", display: true},
      {left: "$", right: "$", display: false},
      {left: "\\(", right: "\\)", display: false}
    ]
  });
});

// Re-render math when navigating to different pages
document.addEventListener("pjax:end", function() {
  renderMathInElement(document.body, {
    delimiters: [
      {left: "$$", right: "$$", display: true},
      {left: "\\[", right: "\\]", display: true},
      {left: "$", right: "$", display: false},
      {left: "\\(", right: "\\)", display: false}
    ]
  });
});