---
layout: post 
title: "相对布局中保持按钮平分"
description: ""
category: mobileApp
tags: []
---

网上看到的，记录下来。

`<RelativeLayout 
    android:layout_width="fill_parent"
    android:layout_height="wrap_content">
    <View android:id="@+id/strut"
        android:layout_width="0dp"
        android:layout_height="0dp" 
        android:layout_centerHorizontal="true"/>
    <Button
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_alignRight="@id/strut"
        android:layout_alignParentLeft="true"
        android:text="Left"/> 
    <Button 
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_alignLeft="@id/strut"
        android:layout_alignParentRight="true"
        android:text="Right"/>
</RelativeLayout>`
