/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %>
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue/dist/vue.esm'
import App from './app.vue'
const axios = require('axios')

Vue.component('Editor', {
  template: '<div :id="editorId" style="width: 100%; height: 100%;"></div>',
  props: ['editorId', 'content'],
  data () {
    return {
      editor: Object,
      beforeContent: this.content
    }
  },
  watch: {
    'content' (value) {
      if (this.beforeContent !== value) {
        this.editor.setValue(value, 1)
      }
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
  const csrf_token = document.getElementsByName('csrf-token').item(0).content;
  const app = new Vue({
    el: '#container',
    data () {
      return {
        result: 'ここにプレビューが表示されます'
      }
    },
    methods: {
      getChildText: function(text) {
        axios.post('/api/handsaws/convert',
          { handsaw: text }, { headers: { 'X-CSRF-Token': csrf_token } }
        ).then(response => {
          this.result = response.data['html'];
        }).catch(error => {
          console.log(error);
        });        
      }
    }
  })
  console.log(app)
})
