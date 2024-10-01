from django.conf import settings
from django.contrib import admin
from django.http import JsonResponse
from django.urls import path, include


def health_check(request):
    return JsonResponse({"status": "ok"})


urlpatterns = [
    path("admin/", admin.site.urls),
    path("health/", health_check, name="health_check"),
    path("", include("django_prometheus.urls")),
]

if settings.DEBUG:
    if "debug_toolbar" in settings.INSTALLED_APPS:
        urlpatterns += [
            path("__debug__/", include("debug_toolbar.urls")),
        ]
