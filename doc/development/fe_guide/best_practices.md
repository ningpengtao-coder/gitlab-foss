# Best Practices

Frontend design patterns and best practices.


## Selectors

When deciding on the selectors to apply or query on an element, you should consider the 3 main use cases of selectors; style, behaviour and testing.

In order to decouple these 3 concerns, you should use different selectors.

1. Style: Any `class` value that does not match an existing prefix.

    Examples: `.general-settings`, `.alert-wrapper`

1. Behaviour: Any `data-` or `class` value prefixed with `js-`. We prefer new changes to use data attributes.

    Examples: `data-js-tooltip`, `.js-navbar`

1. Testing/QA: Any `data-` or `class` value prefixed with `qa-`. We prefer new changes to use data attributes.

    Examples: `data-qa-projects-dropdown`, `.qa-your-projects-link`

> The mark of maintainable HTML, CSS, and JavaScript is when individual developers can easily and confidently edit parts of the code base without those changes inadvertently affecting other, unrelated parts.
>
> From [Decoupling Your HTML, CSS, and JavaScript](https://philipwalton.com/articles/decoupling-html-css-and-javascript/).

## Singletons

When exactly one object is needed for a given task, prefer to define it as a
`class` rather than as an object literal. Prefer also to explicitly restrict
instantiation, unless flexibility is important (e.g. for testing).

```javascript
// bad

const MyThing = {
  prop1: 'hello',
  method1: () => {}
};

export default MyThing;

// good

class MyThing {
  constructor() {
    this.prop1 = 'hello';
  }
  method1() {}
}

export default new MyThing();

// best

export default class MyThing {
  constructor() {
    if (!this.prototype.singleton) {
      this.init();
      this.prototype.singleton = this;
    }
    return this.prototype.singleton;
  }

  init() {
    this.prop1 = 'hello';
  }

  method1() {}
}

```

## Manipulating the DOM in a JS Class

When writing a class that needs to manipulate the DOM guarantee a container option is provided.
This is useful when we need that class to be instantiated more than once in the same page.

Bad:

```javascript
class Foo {
  constructor() {
    document.querySelector('.bar');
  }
}
new Foo();
```

Good:

```javascript
class Foo {
  constructor(opts) {
    document.querySelector(`${opts.container} .bar`);
  }
}

new Foo({ container: '.my-element' });
```

You can find an example of the above in this [class][container-class-example];

[container-class-example]: https://gitlab.com/gitlab-org/gitlab-ce/blob/master/app/assets/javascripts/mini_pipeline_graph_dropdown.js
