package com.example.example_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.os.Bundle
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * App Widget màn hình chính: hiển thị ảnh lịch do Flutter render.
 * Chọn ảnh theo chiều cao widget → resize để đổi 1 tuần / 2 tuần / tháng.
 * (Android không hỗ trợ widget màn hình khóa — chỉ home screen.)
 */
class CalendarWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        for (id in appWidgetIds) {
            val options = appWidgetManager.getAppWidgetOptions(id)
            render(context, appWidgetManager, id, widgetData, options)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle,
    ) {
        render(
            context,
            appWidgetManager,
            appWidgetId,
            HomeWidgetPlugin.getData(context),
            newOptions,
        )
    }

    private fun render(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        widgetData: SharedPreferences,
        options: Bundle,
    ) {
        val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 0)
        val key = when {
            minHeight >= 220 -> "cal_month"
            minHeight >= 130 -> "cal_twoWeeks"
            else -> "cal_week"
        }

        val views = RemoteViews(context.packageName, R.layout.widget_calendar)
        val path = widgetData.getString(key, null)
        if (path != null) {
            val bitmap = BitmapFactory.decodeFile(path)
            if (bitmap != null) views.setImageViewBitmap(R.id.widget_image, bitmap)
        }

        // Bấm widget → mở app.
        val pending = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
        views.setOnClickPendingIntent(R.id.widget_root, pending)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}
