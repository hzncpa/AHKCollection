; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=67267

stringSimilarity := new stringsimilarity()

; ======================= 两组字符串相似度对比 ======================
; compareTwoStrings(string1, string2)
; 从 0 到 1 的分数，两者都包括在内。数字越大表示相似度越高。比较不区分大小写。

; /* 两组字符串对比，返回相似度

MsgBox % stringSimilarity.compareTwoStrings("你好我好大家好", "我好大家好你好") ; => 0.83

MsgBox % stringSimilarity.compareTwoStrings("healed", "sealed") ; => 0.80

MsgBox % stringSimilarity.compareTwoStrings("Olive-green table for sale, in extremely good condition.", "For sale: table in very good  condition, olive green in colour.") ; => 0.70

; MsgBox % stringSimilarity.compareTwoStrings("Olive-green table for sale, in extremely good condition.", "For sale: green Subaru Impreza, 210,000 miles") ; => 0.34

; MsgBox % stringSimilarity.compareTwoStrings("Olive-green table for sale, in extremely good condition.", "Wanted: mountain bike with at least 21 gears.") ; => 0.14

; 比较相似度不区分大小写
; StringCaseSense, On ; 官网示例中这个参数好像没有影响
MsgBox % stringSimilarity.compareTwoStrings("thereturnoftheking", "TheReturnoftheKing") ; => 1
; StringCaseSense, Off

MsgBox % stringSimilarity.compareTwoStrings("The eturn of the king", "The Return of the King") ; => 0.93
MsgBox % stringSimilarity.compareTwoStrings("set", "ste") ; => 0

*/

; =================== 返回数组中字符串的相似度 ====================

; findBestMatch(mainString, targetStrings)
; 比较主字符串 针对每个字符串 目标字符串.

; 参数：
; mainString (string)：与每个目标字符串匹配的字符串。
; targetStrings (Array)：此数组中的每个字符串都将与主字符串进行匹配。

; (Object): 一个对象收视率 属性，它给出了每个目标字符串的相似性评级，以及 最佳匹配属性，指定哪个目标字符串与主字符串最相似。的数组收视率从最高评分到最低评分。

testVar := stringSimilarity.findBestMatch("similar", ["levenshtein","matching","similarity"])

/* 数组内3组字符串与目标"similar"的相似度

MsgBox % testVar.ratings.count() ; => 3
MsgBox % testVar.ratings[1].target ; => similarity
MsgBox % testVar.ratings[1].rating ; => 0.80
MsgBox % testVar.ratings[2].target ; => matching
MsgBox % testVar.ratings[2].rating ; => 0
MsgBox % testVar.ratings[3].target ; => levenshtein
MsgBox % testVar.ratings[3].rating ; => 0

*/


/*

; testVar找出数组中最相似的字符串，返回相似度
MsgBox % testVar.bestMatch.target ; => similarity
MsgBox % testVar.bestMatch.rating ; => 0.80

; testVar2找出数组中最相似的字符串，返回相似度
testVar2 := stringSimilarity.findBestMatch("Hard to", [" hard to    ","hard to","Hard 2"])
MsgBox % testVar2.bestMatch.target ; => hard to
MsgBox % testVar2.bestMatch.rating ; => 1

*/


; ======================= 找出最相似的字符串 ======================

; simpleBestMatch(mainString, targetStrings)
; 比较主字符串 针对每个字符串 目标字符串.

; 参数：
; mainString (string)：与每个目标字符串匹配的字符串。
; targetStrings (Array)：此数组中的每个字符串都将与主字符串进行匹配。

; 返回（字符串）：与第一个参数字符串最相似的字符串。

/*

MsgBox % stringSimilarity.simpleBestMatch("我是", ["你是第一名","我是第二名","他是第三名"]) ; => 我是第二名
MsgBox % stringSimilarity.simpleBestMatch("setting", ["ste","one","set"]) ; => set
MsgBox % stringSimilarity.simpleBestMatch("Smart", ["smarts","smrt","clip-art"]) ; => smarts
MsgBox % stringSimilarity.simpleBestMatch("Olive-green table", ["green Subaru Impreza","table in very good","mountain bike with"]) ; => table in very good

MsgBox % stringSimilarity.simpleBestMatch("Olive-green table for sale, in extremely good condition."
    , ["For sale: green Subaru Impreza, 210,000 miles"
    , "For sale: table in very good condition, olive green in colour."
    , "Wanted: mountain bike with at least 21 gears."]) ; => For sale: table in very good condition, olive green in colour.
	
*/
ExitApp


; ======================== 字符串相似性类库 ========================

class stringsimilarity {

	; --- Static Methods ---

	compareTwoStrings(param_string1, param_string2) {
		;Sørensen-Dice coefficient
		savedBatchLines := A_BatchLines
		setBatchLines, -1

		vCount := 0
		;make default key value 0 instead of a blank string
		l_arr := {base:{__Get:func("abs").bind(0)}}
		loop, % vCount1 := strLen(param_string1) - 1 {
			l_arr["z" subStr(param_string1, A_Index, 2)]++
		}
		loop, % vCount2 := strLen(param_string2) - 1 {
			if (l_arr["z" subStr(param_string2, A_Index, 2)] > 0) {
				l_arr["z" subStr(param_string2, A_Index, 2)]--
				vCount++
			}
		}
		vSDC := round((2 * vCount) / (vCount1 + vCount2), 2)
		;round to 0 if less than 0.005
		if (!vSDC || vSDC < 0.005) {
			return 0
		}
		; return 1 if rounded to 1.00
		if (vSDC = 1) {
			return 1
		}
		setBatchLines, % savedBatchLines
		return vSDC
	}


	findBestMatch(param_string, param_array) {
		savedBatchLines := A_BatchLines
		setBatchLines, -1
		if (!isObject(param_array)) {
			setBatchLines, % savedBatchLines
			return false
		}

		l_arr := []

		; Score each option and save into a new array
		for key, value in param_array {
			l_arr[A_Index, "rating"] := this.compareTwoStrings(param_string, value)
			l_arr[A_Index, "target"] := value
		}

		;sort the rated array
		l_sortedArray := this._internal_Sort2DArrayFast(l_arr, "rating")
		; create the besMatch property and final object
		l_object := {bestMatch: l_sortedArray[1].clone(), ratings: l_sortedArray}
		setBatchLines, % savedBatchLines
		return l_object
	}


	simpleBestMatch(param_string, param_array) {
		if (!IsObject(param_array)) {
			return false
		}
		l_highestRating := 0

		for key, value in param_array {
			l_rating := this.compareTwoStrings(param_string, value)
			if (l_highestRating < l_rating) {
				l_highestRating := l_rating
				l_bestMatchValue := value
			}
		}
		return l_bestMatchValue
	}



	_internal_Sort2DArrayFast(param_arr, param_key)
	{
		for index, obj in param_arr {
			out .= obj[param_key] "+" index "|"
			; "+" allows for sort to work with just the value
			; out will look like:   value+index|value+index|
		}

		v := param_arr[param_arr.minIndex(), param_key]
		if v is number
			type := " N "
		out := subStr(out, 1, strLen(out) -1) ; remove trailing |
		sort, out, % "D| " type  " R"
		l_arr := []
		loop, parse, out, |
			l_arr.push(param_arr[subStr(A_LoopField, inStr(A_LoopField, "+") + 1)])
		return l_arr
	}
}