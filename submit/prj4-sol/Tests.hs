module Main (main) where

import Test.QuickCheck

import TestUtils
import Prj4Sol


-------------------------------- oddSquares -----------------------------

propOddSquares n = (take n oddSquares) == (map (^2) $ take n [1, 3..])

testOddSquares = do
  putStrLn $ testHdr "oddSquares"
  propTest "must generate all odd squares" propOddSquares


--------------------------- countDistincts ------------------------------

propCountDistincts n =
  (countDistincts ls) == freq
  where
    freq = map (\a -> (a, a)) [1..n]
    ls = concat $ map (\a -> replicate a a) [1..n]
 

testCountDistincts = do
  putStrLn $ testHdr "countDistincts"
  ioTest "countDistincts empty" (countDistincts ([]::[Int])) []
  ioTest "countDistincts \"Mississippi\"" (countDistincts "Mississippi")
                                [ ('M', 1), ('i', 4), ('p', 2), ('s', 4) ]
  propTest "prop countDistincts" propCountDistincts                             

---------------------------------- scan ---------------------------------

testScan = do
  putStrLn $ testHdr "scan"
  ioTest "scan empty" (scan "  ")  []
  ioTest "scan ints" (scan "22 -33") [ (Val 22), (Val (-33)) ]
  ioTest "scan ops" (scan "+ - * /")
                    [ BinOp ("+", (+)), BinOp ("-", (-)),
                      BinOp ("*", (*)), BinOp ("/", div) ]
  ioTest "scan \"+ 22 * 33 11\"" (scan "+ 22 * 33 11")
                    [ BinOp ("+", (+)), Val 22,
                      BinOp ("*", (*)), Val 33, Val 11]
  ioTest "scan unknown" (scan "++ 2x") [ Unknown "++", Unknown "2x" ]

----------------------------evalPrefixExpr ------------------------------

testEvalPrefixExpr = do
  putStrLn $ testHdr "evalPrefixExpr"
  ioTest "eval \"22\" == 22" (evalPrefixExpr " 22 ") (Just 22)
  ioTest "eval \"+ 22 33\" == 55" (evalPrefixExpr "+ 22 33") (Just 55)
  ioTest "eval \"+ * 2 3 - 7 / 4 2\" == 11" (evalPrefixExpr "+ * 2 3 - 7 / 4 2")
               (Just 11)
  ioTest "eval \"22 33\" fails" (evalPrefixExpr " 22 33 ") Nothing
  ioTest "eval \"*22 33\" fails" (evalPrefixExpr " *22 33 ") Nothing
  ioTest "eval \"+ 22\" fails" (evalPrefixExpr "+ 22") Nothing
  ioTest "eval \"\" fails" (evalPrefixExpr "  ") Nothing

------------------------------ firstOk ----------------------------------


testFirstOk =
  do
    putStrLn $ testHdr "firstOk"
    ioTest "firstOk >5" (firstOk fn1 [2, 3, 8, 4]) (Just (8, True))
    ioTest "firstOk length>2" (firstOk fn2 [[2, 3], [3, 8, 4]])
                                      (Just ([3, 8, 4], 3))
  where                               
    fn1 = (\x -> if x > 5; then Just True; else Nothing)
    fn2 = \x -> if length x > 2; then Just (length x); else Nothing

-------------------------------- allMatches -----------------------------

testAllMatches = do
  putStrLn $ testHdr "allMatches"
 
  -- (Str _)
  ioTest "allMatches \"aabc\" //" (allMatches "aabc" (Str "")) [ ("", "aabc") ]
  ioTest "allMatches \"aabc\" /a/"
         (allMatches "aabc" (Str "a"))
         [ ("a", "abc") ]
  ioTest "allMatches \"aabc\" /aa/"
         (allMatches "aabc" (Str "aa"))
         [ ("aa", "bc") ]
  ioTest "allMatches \"aabc\" /aab/"
         (allMatches "aabc" (Str "aab"))
         [ ("aab", "c") ]
  ioTest "allMatches \"aabc\" /aabb/ fail"
         (allMatches "aabc" (Str "aabb"))
         []

  -- (Cat (Str _) (Str _))
  ioTest "allMatches \"abc\" /a b/"
         (allMatches "abc" (Cat (Str "a") (Str "b")))
         [ ("ab", "c") ]
  ioTest "allMatches \"abcdd\" /ab cd/"
         (allMatches "abcdd" (Cat (Str "ab") (Str "cd")))
         [ ("abcd", "d") ]
  ioTest "allMatches \"abca\" /ab cd/ fail"
         (allMatches "abca" (Cat (Str "ab") (Str "cd")))
         []

  -- (Alt (Str _) (Str _))
  ioTest "allMatches \"abcd\" /ab|cd/"
         (allMatches "abcd" (Alt (Str "ab") (Str "cd")))
         [ ("ab", "cd") ]
  ioTest "allMatches \"abcd\" /cd|ab/"
         (allMatches "abcd" (Alt (Str "cd") (Str "ab")))
         [ ("ab", "cd") ]
  ioTest "allMatches \"abcd\" /ab|abc/"
         (allMatches "abcd" (Alt (Str "ab") (Str "abc")))
         [ ("ab", "cd"), ("abc", "d") ]
  ioTest "allMatches \"axcd\" /ab|abc/ fail"
         (allMatches "axcd" (Alt (Str "ab") (Str "abc")))
         []

  -- (Rep (Str _))
  ioTest "allMatches \"aaab\" /a*/"
          (allMatches "aaab" (Rep (Str "a")))
          [ ("aaa", "b"), ("aa", "ab"), ("a", "aab"), ("", "aaab") ]
  ioTest "allMatches \"ababab\" /(ab)*/"
         (allMatches "ababab" (Rep (Str "ab")))
         [ ("ababab", ""), ("abab", "ab"), ("ab", "abab"), ("", "ababab") ]
  ioTest "allMatches \"xaa\" /a*/"
         (allMatches "xaa" (Rep (Str "a")))
         [ ("", "xaa") ]

  -- Complex regexs with backtracking
  ioTest "allMatches \"aaabb\" /a*ab/"
         (allMatches "aaabb" (Cat (Rep (Str "a")) (Str "ab")))
         [ ("aaab", "b") ]
  ioTest "allMatches \"aaabb\" /a*aab/"
         (allMatches "aaabb" (Cat (Rep (Str "a")) (Str "aab")))
         [ ("aaab", "b") ]
  ioTest "allMatches \"abccccdd\" /aba|abcc*/"
         (allMatches "abccccdd" (Alt (Str "aba")
                                     (Cat (Str "abc") (Rep (Str "c")))))
         [ ("abcccc", "dd"), ("abccc", "cdd"), ("abcc", "ccdd"),
           ("abc", "cccdd") ]


------------------------------ matchAt ----------------------------------

testMatchAt = do
  putStrLn $ testHdr "matchAt"
  ioTest "matchAt \"aaabb\" /a*ab/"
         (matchAt "aaabb" (Cat (Rep (Str "a")) (Str "ab")))
         (Just "aaab")
  ioTest "matchAt \"aaabb\" /a*aab/"
         (matchAt "aaabb" (Cat (Rep (Str "a")) (Str "aab")))
         (Just "aaab")
  ioTest "matchAt \"abccccdd\" /aba|abcc*/"
         (matchAt "abccccdd" (Alt (Str "aba")
                                  (Cat (Str "abc") (Rep (Str "c")))))
         (Just "abcccc")

  -- (aba|abccc*                   
  ioTest "matchAt \"abc\" /aba|abcc*/ fail"
         (matchAt "abc" (Alt (Str "aba")
                             (Cat (Str "abcc") (Rep (Str "c")))))
         Nothing


--------------------------------- match ---------------------------------

testMatch = do
  putStrLn $ testHdr "match"
  ioTest "match \"aab\" /b/" (match "aab" (Str "b")) (Just (2, "b"))
  ioTest "match \"aab\" /a*b/" (match "aab" (Cat (Rep (Str "a")) (Str "b")))
         (Just (0, "aab"))
  ioTest "match \"aab\" /a*bb/ fail"
         (match "aab" (Cat (Rep (Str "a")) (Str "bb")))
          Nothing
  ioTest "match \"baab\" /ab*/" (match "baaab" (Cat (Str "a") (Rep (Str "b"))))
         (Just (1, "a"))
  ioTest "match \"baabbba\" /abb*/" (match "baabbba"
                                           (Cat (Str "ab") (Rep (Str "b"))))
         (Just (2, "abbb"))
  ioTest "match \"baabb\" /abb*/ fail"
         (match "baabb" (Cat (Str "abbb") (Rep (Str "b"))))
         Nothing
  ioTest "match \"abbabaddda\" /abc|abad*/"
         (match "abbabaddda" (Alt (Str "abc")
                              (Cat (Str "aba") (Rep (Str "d")))))
         (Just (3, "abaddd"))
  ioTest "match \"caabaaaabbba\" /aaaa*b*/"
         (match "caabaaaabbba" (Cat (Cat (Str "aaa") (Rep (Str "a")))
                                    (Rep (Str "b"))))
         (Just (4, "aaaabbb"))

------------------------------- All Tests -------------------------------

-- Can mark test suites with following test statuses:
--   Only:  run only these tests and other tests marked Only.
--   Run:   run these tests when no tests are marked Only.
--   Skip:  skip these tests.
allTests = [
    (Run testOddSquares),
    (Run testCountDistincts),
    (Run testScan),
    (Run testEvalPrefixExpr),
    (Run testFirstOk),
    (Run testAllMatches),
    (Run testMatchAt),
    (Run testMatch)
  ]


main = do
  mapM_ id tests
  where
    only = onlyTests allTests
    tests = if (length only > 0) then only else runTests allTests
