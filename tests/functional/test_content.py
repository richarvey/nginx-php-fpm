''' Crawl site and validate every page renders somewhat correctly '''
import unittest
import re
import requests

class ContentTest(unittest.TestCase):
    ''' Run a functional test to validate content being served '''

    def setUp(self):
        ''' Create some starter data to be used in tests '''
        self.domain = "http://127.0.0.1"
        self.search_string = "Version"

    def tearDown(self):
        ''' Destroy starter data '''
        self.domain = None
        self.search_string = "None"

    def request_recurse(self, url, requested=None):
        ''' recursively request each page checking the return code and urls '''
        counts = {
            'pass' : 0,
            'fail' : 0,
        }
        if requested is None:
            requested = []
        if url in requested:
            return counts, requested
        else:
            requested.append(url)
        url = self.domain + url
        results = requests.get(url, allow_redirects=True, verify=False)
        if self.search_string in results.text:
            counts['pass'] = counts['pass'] + 1
        else:
            counts['fail'] = counts['fail'] + 1
        urls = re.findall(
            'href="/(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\(\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+',
            results.text
        )
        for url in urls:
            url = url.lstrip('href="')
            if "/static/" not in url:
                if "//" not in url:
                    results, requested = self.request_recurse(url, requested=requested)
                    # Add counts for status codes
                    for key in results.keys():
                        if key in counts:
                            counts[key] = counts[key] + results[key]
                        else:
                            counts[key] = results[key]
        return counts, requested

class CrawlSite(ContentTest):
    ''' Verify no broken links are present within blog '''
    def runTest(self):
        ''' Execute recursive request '''
        results, requested_pages = self.request_recurse("/")
        self.assertFalse(
            results['fail'] > 0,
            "Found {0} pages that did not return keyword".format(results['fail'])
        )
