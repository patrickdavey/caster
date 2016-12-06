import Vue from 'vue'
import Cast from '../../../web/static/js/components/Cast.vue'

describe('Viewed Cast', () => {
  var vm;

  beforeEach(() => {
    vm = new Vue({
      data: { cast: {name: 'testName', id: 1,  state: 'viewed'}, removeable: true },
      template: '<div><cast :removeable="removeable" :cast="cast"></cast></div>',
      components: { Cast }
    }).$mount();
  })

  afterEach(() =>
    vm = null
  )

  it('should link to rewatching the video', () => {
    expect(vm.$el.querySelector('a[href="/casts/1"]')).toBeTruthy()
  });

  it('should link to deleting the video', () => {
    expect(vm.$el.querySelector('button[name="removeDownload"]')).toBeTruthy()
  });
});
