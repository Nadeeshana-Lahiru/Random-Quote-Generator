package com.example.random_quote_generator

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class QuoteWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.quote_widget).apply {
                val quoteText = widgetData.getString("quote_text", "Generating Inspiration...")
                val quoteAuthor = widgetData.getString("quote_author", "- Quote Generator")
                setTextViewText(R.id.quote_text, quoteText)
                setTextViewText(R.id.quote_author, quoteAuthor)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
