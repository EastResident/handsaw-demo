/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %>
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue/dist/vue.esm'
import App from './app.vue'

Vue.component('Editor', {
  template: '<div :id="editorId" style="width: 100%; height: 100%;"></div>',
  props: ['editorId', 'content'],
  data () {
    return {
      editor: Object,
      beforeContent: this.content
    }
  },
  mounted () {   
    this.editor = window.ace.edit(this.editorId)
    this.editor.setValue(this.content, 1)
    this.editor.setTheme("ace/theme/monokai");
    this.editor.getSession().setMode("ace/mode/markdown");
    this.editor.getSession().setTabSize(2);
    this.editor.getSession().setUseWrapMode(true);
 
    this.editor.on('change', () => {
      this.beforeContent = this.editor.getValue()
      this.$emit('change-content', this.editor.getValue())
    })
  }
})

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#container',
    data () {
      return {
        result: 'ここにプレビューが表示されます'
      }
    },
    components: { App },
    methods: {
      apply (val) {

        // if (this.result !== val) {
        //   $('#pre_article_markdown').val(val)
        //   this.$http.post('/api/markdowns/to_html', { markdown: val }).then(response => {
        //     this.result = response.body['html'];
        //   }, response => {
        //   });
        // }
        this.result = val
      }
    }
  })

  console.log(app)
})
