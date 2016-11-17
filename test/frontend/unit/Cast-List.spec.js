import Vue from 'vue'
import CastList from '../../../web/static/js/components/Cast-List.vue'

describe('CastList.vue', () => {
  it('should have a refresh button', (done) => {
    var mount = document.createElement('div');
    const vm = new CastList({
      el: mount,
      propsData: {
        initialFetchComplete: true,
        refreshable: true
      }
    })
    expect(vm.$el.querySelector('button[name=refresh]')).toBeTruthy();
    vm.refreshable = false;
    vm.$nextTick(() => {
      expect(vm.$el.querySelector('button[name=refresh]')).toBeFalsy();
      done();
    });
  });
});
