import Vue from 'vue';
import component from '~/releases/components/release_block.vue';
import timeagoMixin from '~/vue_shared/mixins/timeago';
import { release } from '../mock_data';

import mountComponent from '../../helpers/vue_mount_component_helper';

describe('Release block', () => {
  const Component = Vue.extend(component);

  let vm;

  const factory = props => mountComponent(Component, { release: props });

  beforeEach(() => {
    vm = factory(release);
  });

  afterEach(() => {
    vm.$destroy();
  });

  it("renders the block with an id equal to the release's tag name", () => {
    expect(vm.$el.id).toBe('18.04');
  });

  it('renders release name', () => {
    expect(vm.$el.textContent).toContain(release.name);
  });

  it('renders commit sha', () => {
    expect(vm.$el.textContent).toContain(release.commit.short_id);
  });

  it('renders tag name', () => {
    expect(vm.$el.textContent).toContain(release.tag_name);
  });

  it('renders release date', () => {
    expect(vm.$el.textContent).toContain(timeagoMixin.methods.timeFormated(release.released_at));
  });

  it('renders number of assets provided', () => {
    expect(vm.$el.querySelector('.js-assets-count').textContent).toContain(release.assets.count);
  });

  it('renders dropdown with the sources', () => {
    expect(vm.$el.querySelectorAll('.js-sources-dropdown li').length).toEqual(
      release.assets.sources.length,
    );

    expect(vm.$el.querySelector('.js-sources-dropdown li a').getAttribute('href')).toEqual(
      release.assets.sources[0].url,
    );

    expect(vm.$el.querySelector('.js-sources-dropdown li a').textContent).toContain(
      release.assets.sources[0].format,
    );
  });

  it('renders list with the links provided', () => {
    expect(vm.$el.querySelectorAll('.js-assets-list li').length).toEqual(
      release.assets.links.length,
    );

    expect(vm.$el.querySelector('.js-assets-list li a').getAttribute('href')).toEqual(
      release.assets.links[0].url,
    );

    expect(vm.$el.querySelector('.js-assets-list li a').textContent).toContain(
      release.assets.links[0].name,
    );
  });

  it('renders author avatar', () => {
    expect(vm.$el.querySelector('.user-avatar-link')).not.toBeNull();
  });

  describe('external label', () => {
    it('renders external label when link is external', () => {
      expect(vm.$el.querySelector('.js-assets-list li a').textContent).toContain('external source');
    });

    it('does not render external label when link is not external', () => {
      expect(vm.$el.querySelector('.js-assets-list li:nth-child(2) a').textContent).not.toContain(
        'external source',
      );
    });
  });

  describe('with upcoming_release flag', () => {
    beforeEach(() => {
      vm = factory(Object.assign({}, release, { upcoming_release: true }));
    });

    it('renders upcoming release badge', () => {
      expect(vm.$el.textContent).toContain('Upcoming Release');
    });
  });
});
