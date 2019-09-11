import { shallowMount } from '@vue/test-utils';
import { GlLoadingIcon } from '@gitlab/ui';

import SidebarTodos from '~/sidebar/components/todo_toggle/todo.vue';
import Icon from '~/vue_shared/components/icon.vue';

const defaultProps = {
  issuableId: 1,
  issuableType: 'epic',
};

describe('SidebarTodo', () => {
  let wrapper;

  const createComponent = (props = {}) => {
    wrapper = shallowMount(SidebarTodos, {
      sync: false,
      propsData: {
        ...defaultProps,
        ...props,
      },
    });
  };

  afterEach(() => {
    wrapper.destroy();
  });

  describe('computed', () => {
    describe('buttonClasses', () => {
      it.each`
        state    | classes
        ${false} | ${'btn btn-default btn-todo issuable-header-btn float-right'}
        ${true}  | ${'btn-blank btn-todo sidebar-collapsed-icon dont-change-state'}
      `(
        'returns todo button classes for when `collapsed` prop is `$state`',
        ({ state, classes }) => {
          createComponent({ collapsed: state });
          expect(wrapper.vm.buttonClasses).toBe(classes);
        },
      );
    });

    describe('buttonLabel', () => {
      it.each`
        isTodo   | label
        ${false} | ${'Add a To Do'}
        ${true}  | ${'Mark as done'}
      `(
        'returns todo button text for add todo when `isTodo` prop is `$isTodo`',
        ({ isTodo, label }) => {
          createComponent({ isTodo });
          expect(wrapper.vm.buttonLabel).toBe(label);
        },
      );
    });

    describe('collapsedButtonIconClasses', () => {
      it.each`
        isTodo   | iconClass
        ${false} | ${''}
        ${true}  | ${'todo-undone'}
      `(
        'returns collapsed button icon class when `isTodo` prop is `$isTodo`',
        ({ isTodo, iconClass }) => {
          createComponent({ isTodo });
          expect(wrapper.vm.collapsedButtonIconClasses).toBe(iconClass);
        },
      );
    });

    describe('collapsedButtonIcon', () => {
      it.each`
        isTodo   | icon
        ${false} | ${'todo-add'}
        ${true}  | ${'todo-done'}
      `('returns button icon name when `isTodo` prop is `$isTodo`', ({ isTodo, icon }) => {
        createComponent({ isTodo });
        expect(wrapper.vm.collapsedButtonIcon).toBe(icon);
      });
    });
  });

  describe('template', () => {
    it('emits `toggleTodo` event when clicked on button', () => {
      createComponent();
      wrapper.find('button').trigger('click');
      expect(wrapper.emitted().toggleTodo).toBeTruthy();
    });

    it('renders component container element with proper data attributes', () => {
      createComponent({
        issuableId: 1,
        issuableType: 'epic',
      });

      expect(wrapper.element).toMatchSnapshot();
    });

    it('check button label computed property', () => {
      createComponent();
      expect(wrapper.vm.buttonLabel).toEqual('Mark as done');
    });

    it('renders button label element when `collapsed` prop is `false`', () => {
      createComponent({ collapsed: false });
      expect(wrapper.find('span.issuable-todo-inner').text()).toBe('Mark as done');
    });

    it('renders button icon when `collapsed` prop is `true`', () => {
      createComponent({ collapsed: true });

      expect(wrapper.find(Icon).props('name')).toBe('todo-done');
    });

    it('renders loading icon when `isActionActive` prop is true', () => {
      createComponent({ isActionActive: true });
      expect(wrapper.find(GlLoadingIcon).exists()).toBe(true);
    });
  });
});
