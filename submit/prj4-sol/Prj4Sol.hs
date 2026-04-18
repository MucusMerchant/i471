module Prj4Sol (
  oddSquares,
  countDistincts,
  Token(..), scan, evalPrefixExpr,
  firstOk,
  Regex(..), MatchResult, allMatches, matchAt, match
  )
where

import Data.List
import Text.Read   -- for readMaybe

-------------------------------- oddSquares -----------------------------

-- #1: "5-points"
-- oddSquares: returns a list of all squares which are odd
-- *Restriction*: must use a list comprehension
-- *Hint*: [1..] returns all integers starting with 1

oddSquares :: [Int]
oddSquares = [x * x | x <- [1..], odd (x * x)]


--------------------------- countDistincts ------------------------------

-- #2: "10-points"
-- countDistincts: Given a list ls :: Ord a => [a], return a list
-- of pairs [(E, Count)] where E is an element of ls and Count is a count
-- of the number of occurrences of E in ls.  The returned list ls
-- must be sorted by E.
--
-- *Restriction*: Cannot use recursion.
-- *Hint*: use group, map, sort.

countDistincts :: Ord a => [a] -> [(a, Int)]
countDistincts ls = map (\g -> (head g, length g)) (group (sort ls))


---------------------------------- scan ---------------------------------

data OpInfo =
  Op (String, (Int->Int->Int))

data Token =
  BinOp (String, Int->Int->Int) |
  Val Int |
  Unknown String

instance Show Token where
  show (BinOp (str, _)) = "(BinOp \"" ++ str ++ "\")"
  show (Val int) = "(Val " ++ show int ++ ")"
  show (Unknown str) = "(Unknown \"" ++ str ++ "\")"

instance Eq Token where
  (BinOp (str1, _)) == (BinOp (str2, _)) = str1 == str2
  (Val int1) == (Val int2) = int1 == int2
  (Unknown str1) == (Unknown str2) = str1 == str2
  _ == _ = False


-- #3: "15-points"
-- scan str: returns list of Tokens corresponding to words in String str.
-- Words "+", "-", "*" and "/" should result in BinOp tokens, otherwise
-- a word consisting of an Int should be mapped to a  Val token, otherwise
-- the word is returned as an Unknown token.
--
-- *Restriction*: cannot use recursion.
-- *Hints*: use (words str) to split str into list of strings and map
-- each word to corresponding token.  The mapping function can use
-- Data.List.find to lookup word in ops (provided below).  If found,
-- the mapping function should return the corresponding BinOp.  If not
-- found, then depending on result of  (readMaybe word) :: (Maybe Int)
-- the mapping function can return either a Val or Unknown token.

ops :: [(String, (Int->Int->Int))]
ops = [ ("+", (+))
      , ("-", (-))
      , ("*", (*))
      , ("/", div)
      ]

scan :: String -> [Token]
scan str = map wordToToken (words str)
  where
    wordToToken word =
      case find (\(op, _) -> op == word) ops of
        Just (op, func) -> BinOp (op, func)
        Nothing ->
          case readMaybe word :: Maybe Int of
            Just n -> Val n
            Nothing -> Unknown word

----------------------------evalPrefixExpr ------------------------------

-- A prefix expression is defined by the following grammar:
-- expr
--  : INT
--  | op expr expr
--  ;
-- op
--  : '+' | '-' | '*' | '/'
--  ;

-- #4: "20-points"
-- evalPrefixExpr str: if str is a String containing a valid prefix expression
-- as per the above grammar, then it should return (Just Val) where Val
-- is the value of the prefix expression, otherwise it should return Nothing.
--
-- *Hints*:
--   + Recurse through the tokens corresponding to str.
--   + A valid top-level prefix expression should consume the entire
--     token list.
--   + When the token list starts with a BinOp, recursively evaluate
--     the tail to get the evaluation of first operand as well as the
--     list of leftover tokens.  Then recursively evaluate the second
--     operand from the leftover tokens.  The value will be the BinOp
--     function applied to the two evaluated operands.
--   + When the token list starts with a Val, then the evaluation
--     is the corresponding Int with the tail of the list constituting
--     the leftover tokens.
--   + Use an auxiliary function (eval tokens) which returns a Maybe
--     with a Just value of (prefixVal, tokensRest), where prefixVal is
--     the value of the prefix expression of a prefix of tokens and
--     tokensRest are the leftover tokens after the prefix.
--     Note that attempting to evaluate an empty token list is an
--     error and should return Nothing.
--   + evalPrefixExpr should first convert str to toks :: [Token]
--     using scan.  If toks is empty or contains a (Unknown _) token
--     (use find), then return Nothing.  Otherwise call auxiliary
--     function eval which returns a Maybe pair. If Just pair, but the
--     snd of the pair is not [], then return Nothing, otherwise
--     return (Just val) where val is fst of the pair.

evalPrefixExpr :: String -> Maybe Int
evalPrefixExpr str =
  let toks = scan str
  in if null toks || any isUnknown toks
     then Nothing
     else case eval toks of
            Just (val, []) -> Just val
            _ -> Nothing
  where
    isUnknown (Unknown _) = True
    isUnknown _ = False

    eval :: [Token] -> Maybe (Int, [Token])
    eval [] = Nothing
    eval (tok:toks) =
      case tok of
        Val n -> Just (n, toks)
        BinOp (_, op) ->
          case eval toks of
            Just (val1, rest1) ->
              case eval rest1 of
                Just (val2, rest2) ->
                  Just (op val1 val2, rest2)
                Nothing -> Nothing
            Nothing -> Nothing
        _ -> Nothing

------------------------------ firstOk ----------------------------------

-- This function will be useful for the regex matcher which follows

-- #5: "10-points"
-- Given a function fn:: a -> Maybe b  and a list ls :: [a], return
-- Maybe (a, b). It should return Just (E, B) where E is the first
-- element in ls for which fn returns Just B.  It should return
-- Nothing if there is no such element.

firstOk :: (a -> Maybe b) -> [a] -> Maybe (a, b)
firstOk fn [] = Nothing
firstOk fn (x:xs) =
  case fn x of
    Just y -> Just (x, y)
    Nothing -> firstOk fn xs

----------------------------- allMatches --------------------------------

data Regex =             -- possibilities for a regex
  Str String |           -- matches a sequence of chars
  Cat Regex Regex |      -- concatenation of regexs R1 R2
  Alt Regex Regex |      -- alternation of regexs R1 | R2
  Rep Regex              -- 0-or-more regexs  R*
  deriving (Eq, Show)

type MatchResult =       -- result for matching a regex at the start of a string
  ( String, String )     -- ( MatchedString, LeftoverString )

-- We build up to a function which scans a string looking for the first
-- match for a regex.
--   allMatches: return all (prefix, suffix) of string such that prefix
--               matches the regex.
--   matchAt:    return a Maybe containing the first string which matches
--               the regex.
--   match:      scan string looking for a match of regex.  Return a Maybe
--               containing the index of the match and the matched string.

-- #6: "20-points"
-- allMatches string regex:
-- return [MatchResult0] containing all matches for regex at start of string.
-- When matching (Alt regex1 regex2), matches for regex1 occur earlier
-- in result list than matches for regex2.
-- (Rep regex) is greedy, i.e. longer matches occur before shorter matches
-- in result list
-- 
-- *Hints*:
-- Write an equation for each case of a Regex
--   + If Regex is a (Str str) then str must be a prefix of string
--     (use isPrefixOf and drop).
--   + If Regex is a (Cat regex1 regex2) then regex2 must match the
--     string leftover after matching regex1.  Use a list-comprehension.
--   + If Regex is a (Alt regex1 regex2) then all matches will be the
--     union of matches for regex1 and matches for regex2.
--   + If Regex is (Rep regex), then it is the same as the regex which
--     matches (Cat regex (Rep regex)) or matches the empty prefix.

allMatches :: String -> Regex -> [MatchResult]
allMatches str regex =
  case regex of
    Str s ->
      if s `isPrefixOf` str
      then [(s, drop (length s) str)]
      else []
    
    Cat r1 r2 ->
      [(s1 ++ s2, rest2) | (s1, rest1) <- allMatches str r1,
                           (s2, rest2) <- allMatches rest1 r2]
    
    Alt r1 r2 ->
      allMatches str r1 ++ allMatches str r2
    
    Rep r ->
      let nonEmpty = [ (s1 ++ s2, rest2) | (s1, rest1) <- allMatches str r,
                                           (s2, rest2) <- allMatches rest1 (Rep r) ]
          zero = [("", str)]
      in nonEmpty ++ zero

-------------------------------matchAt ----------------------------------

-- #7: "10-points"
-- matchAt str regex: returns (Just matchStr) if matchStr is a
-- prefix of str which matches regex.  Otherwise return Nothing.
--
-- *Hints*: If allMatches returns a non-empty list, return
-- Just first matching string.  Otherwise return Nothing.

matchAt :: String -> Regex -> Maybe String
matchAt str regex =
  case allMatches str regex of
    [] -> Nothing
    (matched, _):_ -> Just matched

--------------------------------- match ---------------------------------

-- #8: "10-points"
-- match str regex: returns Maybe (Int, String).  Should return
-- (Just (index, matchStr)) where index is the smallest index in str
-- where regex matches string matchStr.  Return Nothing if there is
-- no such index.
--
-- *Hints*: use firstOk and matchAt to scan over indexes in str.

match :: String -> Regex -> Maybe (Int, String)
match str regex =
  let suffixes = [drop i str | i <- [0..length str]]
  in case firstOk (\s -> matchAt s regex) suffixes of
       Just (suffix, matched) ->
         let index = length str - length suffix
         in Just (index, matched)
       Nothing -> Nothing
