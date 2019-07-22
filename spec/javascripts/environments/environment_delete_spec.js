import Vue from 'vue';
import deleteComp from '~/environments/components/environment_delete.vue';

describe('Delete Component', () => {
  let DeleteComponent;
  let component;

  beforeEach(() => {
    DeleteComponent = Vue.extend(deleteComp);
    spyOn(window, 'confirm').and.returnValue(true);

    component = new DeleteComponent({
      propsData: {
        environment: {},
      },
    }).$mount();
  });

  it('should render a button to delete the environment', () => {
    expect(component.$el.tagName).toEqual('BUTTON');
    expect(component.$el.getAttribute('data-original-title')).toEqual('Delete environment');
  });
});
