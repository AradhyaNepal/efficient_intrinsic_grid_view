## Still On Development:
This package is still on development phase, will update\improve readme and its functionality once its developed.
Lots of task still on the way

## Introduction

A GridView which allowed every crossAxis to have its own intrinsic size, i.e.
its own intrinsic height for vertical scrolling or its own intrinsic width for horizontal scrolling.
### What is Intrinsic?
Lets say, you are using GridView with vertical scrolling, in this case crossAxis means every Row.
Lets assume that every Row's element have its own different height, and while rendering a specific Row,
you want to set height of the maximum element of that specific Row,
that's called setting intrinsic size of every crossAxis of a [GridView].

By default [GridView] does not allows this, in [GridView] you have to set a one fixed mainAxisExtent
or internally [GridView] will automatically calculates one mainAxisExtent for every crossAxis.
Lets say A crossAxis have max size X and B crossAxis have max size Y.
In [GridView] you are forced to use only one mainAxisExtent, say Y.
So even A crossAxis have to use Y mainAxisExtent, leaving unnecessary white spaces.

And that's how I come up with an idea of creating this package!.
In this package we have multiple mainAxisExtent as per every crossAxis's elements max size.

### But why there is Efficient word in my package??
Because it's efficient.

This Intrinsic name was inspired from [IntrinsicHeight] and [IntrinsicWidth] widget provided by Flutter framework.
To demonstrate what inefficiency is, I have also created [EfficientIntrinsicGridView.shrinkWrap],
which is made from combination of [IntrinsicHeight] and [IntrinsicWidth]
on scrollable [Row] and [Column] to render the gridview.
I have named it shrinkWrap, because most of new developer learns about shrinkWrap
when flutter is throwing has infinite size error on Scrolling item.
This widget prevents that error.

But lets say there are 1000 items on a [GridView], [IntrinsicHeight] and [IntrinsicWidth] are already an expensive widget,
and when you are using [EfficientIntrinsicGridView.shrinkWrap] you are rendering all the expensive 1000 widgets at once.
Huge memory will be used by the app, sometimes your app can even crash
if your memory consumption is higher than RAM memory available.
That's why don't use [EfficientIntrinsicGridView.shrinkWrap], its inefficient.

Regarding has infinite size, I personally hate using shrinkWrap true on [GridView].
So either set use proper sizing of the widgets or from [IntrinsicController]
you can access total calculated size of the [EfficientIntrinsicGridView],
or my favorite way is to use [CustomScrollView].

Now lets come to the efficient solutions:

[EfficientIntrinsicGridView] and [EfficientIntrinsicGridView.builder]

Both have there own efficient algorithm to calculate intrinsic mainAxisExtent of crossAxis items,
without using expensive [IntrinsicHeight] and [IntrinsicWidth] widget.
Unlike [EfficientIntrinsicGridView.shrinkWrap], it does not renders all 1000 elements at once.
After calculating the size, custom [SliverGridDelegate] of this [EfficientIntrinsicGridView]
renders only the element which is visible to the user, plus one extra buffer.
Whether the items available are 100 or 1000, the memory consumption
while rendering those elements will remain the same.

And that's why its efficient!
