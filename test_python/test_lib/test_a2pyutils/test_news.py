import unittest
from mock import MagicMock

class Test_news(unittest.TestCase):

    def test_insertNews(self):
        try:
            from a2pyutils.news import insertNews
        except ImportError:
            self.fail("Cannot load a2pyutils.news module")
        
        cursor_mock = MagicMock()
        cursor_mock.execute = MagicMock()
        insertNews(cursor_mock, 1, 1, "this is the news", 1)
        self.assertIsNone(cursor_mock.execute.assert_any_call('\n        INSERT INTO project_news(user_id, project_id, data, news_type_id)\n        VALUES (%s, %s, %s, %s)\n    ', [1, 1, 'this is the news', 1]))
        
if __name__ == '__main__':
    unittest.main()
