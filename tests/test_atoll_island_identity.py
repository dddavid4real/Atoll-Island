import pathlib
import plistlib
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]


class AtollIslandIdentityTests(unittest.TestCase):
    def test_product_identity_is_distinct_from_upstream_atoll(self):
        project = (ROOT / "DynamicIsland.xcodeproj" / "project.pbxproj").read_text()
        scheme = (
            ROOT
            / "DynamicIsland.xcodeproj"
            / "xcshareddata"
            / "xcschemes"
            / "DynamicIsland.xcscheme"
        ).read_text()

        self.assertEqual(project.count('PRODUCT_NAME = "Atoll Island";'), 2)
        self.assertEqual(
            project.count('INFOPLIST_KEY_CFBundleDisplayName = "Atoll Island";'),
            2,
        )
        self.assertIn(
            "PRODUCT_BUNDLE_IDENTIFIER = com.dddavid4real.AtollIsland.dev;",
            project,
        )
        self.assertIn(
            "PRODUCT_BUNDLE_IDENTIFIER = com.dddavid4real.AtollIsland;",
            project,
        )
        self.assertNotIn(
            "PRODUCT_BUNDLE_IDENTIFIER = com.Ebullioscopic.Atoll;",
            project,
        )
        self.assertEqual(scheme.count('BuildableName = "Atoll Island.app"'), 3)

    def test_personal_build_cannot_follow_upstream_sparkle_feed(self):
        app_source = (ROOT / "DynamicIsland" / "DynamicIslandApp.swift").read_text()
        updater_delegate = (
            ROOT / "DynamicIsland" / "services" / "AtollUpdaterDelegate.swift"
        ).read_text()
        info_plist = plistlib.loads(
            (ROOT / "DynamicIsland" / "Info.plist").read_bytes()
        )

        self.assertIn("startingUpdater: false", app_source)
        self.assertNotIn("CheckForUpdatesView(updater:", app_source)
        self.assertNotIn("Ebullioscopic/Atoll", updater_delegate)
        self.assertNotIn("SUFeedURL", info_plist)
        self.assertNotIn("SUPublicEDKey", info_plist)

    def test_user_visible_shell_uses_atoll_island_name(self):
        app_source = (ROOT / "DynamicIsland" / "DynamicIslandApp.swift").read_text()
        welcome_source = (
            ROOT / "DynamicIsland" / "components" / "Onboarding" / "WelcomeView.swift"
        ).read_text()
        settings_window = (
            ROOT
            / "DynamicIsland"
            / "components"
            / "Settings"
            / "SettingsWindowController.swift"
        ).read_text()

        self.assertIn('Button("Restart Atoll Island")', app_source)
        self.assertIn('Text("Atoll Island")', welcome_source)
        self.assertIn('window.title = "Atoll Island Settings"', settings_window)


if __name__ == "__main__":
    unittest.main()
