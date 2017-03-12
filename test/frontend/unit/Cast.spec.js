/* global describe, it, expect */

import Vue from 'vue'
import Cast from '../../../web/static/js/components/Cast.vue'

describe('Cast.vue', () => {
  it('should render name of cast correctly', () => {
    var mount = document.createElement('div');
    const vm = new Cast({
      el: mount,
      propsData: { cast: {title: 'testName'} },
    })
    expect(vm.$el.querySelector('tr td').textContent.trim()).toBe('testName')
  });

  it('should conditionally render remove button', () => {
    var mount = document.createElement('div');
    const vm = new Cast({
      el: mount,
      propsData: { cast: {
        title: 'testName',
        state: "downloaded"
      },
      removeable: false
      }
    })
    expect(vm.$el.querySelector('button[name="removeDownload"]')).toBeFalsy()
  });


  describe('fresh casts', () => {
    var vm;
    var testComponent;

    beforeEach(() => {
      Vue.use(require('vue-resource'));
      vm = new Vue({
        data: { cast: {name: 'testName', id: 1,  state: 'fresh'} },
        template: '<div><cast ref=\'testComponent\' :cast="cast"></cast></div>',
        components: { Cast }
      }).$mount();

      testComponent = vm.$refs.testComponent;
    })

    afterEach(() =>
      vm = null
    )

    it('should have a download button', () => {
      expect(vm.$el.querySelector('button[name="download"]')).toBeTruthy()
    });

    it('should change the state to downloading if downloadStarted called', () => {
      testComponent.downloadStarted();
      expect(testComponent.cast.state).toBe('downloading');
    });
  });

  describe('downloading cast', () => {
    var vm;

    beforeEach(() =>
      vm = new Vue({
        data: { cast: {name: 'testName', state: 'downloading'} },
        template: '<div><cast :cast="cast"></cast></div>',
        components: { Cast }
      }).$mount()
    )

    afterEach(() =>
      vm = null
    )

    it('should not have a download button', () => {
      expect(vm.$el.querySelector('button[name="download"]')).toBeFalsy();
      expect(vm.$el.outerHTML).toMatch(/Downloading\.\.\./);
    });
  });
})
