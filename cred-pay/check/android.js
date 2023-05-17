PackageManager packageManager = context.getPackageManager();
try {
    packageManager.getPackageInfo(packageName, 0);
    // app found
} catch (PackageManager.NameNotFoundException e) {
    // app not found
}