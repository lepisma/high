;; Macro collection

(import [colorama [Fore Style]])
(import colorama)
(import [eep [Searcher]])

(colorama.init :autoreset True)

(defmacro async-defn [name args &rest body]
  `(do
     (import asyncio)
     (with-decorator asyncio.coroutine
       (def ~name (fn [~@args] (do ~@body))))))

(defmacro with-fp [file-name &rest body]
  `(with [fp (open ~file-name)]
     ~@body))

(defmacro await [stuff]
  `(yield-from ~stuff))

(defmacro let [definitions &rest body]
  "Dummy let. Just for asthetics."
  (setv n (len definitions)
        i 0)
  (setv out-exp '())
  (while (< i n)
    (.append out-exp
             `(setv ~(nth definitions i) ~(nth definitions (+ i 1))))
    (setv i (+ i 2)))
  (.append out-exp `(do ~@body))
  `(do ~@out-exp))

(defn separate-fsubs (txt)
  "Separate fstring substitutions and cleared string"
  (let [es (Searcher txt)
        fsubs []
        opening-enc "{"
        closing-enc "}"]
    (while (es.search-forward opening-enc)
      (setv begin es.point)
      (es.search-forward closing-enc)
      (es.swap-markers)
      (setv es.mark begin)
      (fsubs.append (es.get-sub))
      (es.erase))
    [fsubs (str es)]))

;; Doesn't work, needs environment too
(defsharp f [f-string]
  (let [[fsubs txt] (separate-fsubs f-string)
        fvals (list (map (fn [x] (eval (read-str x))) fsubs))]
    `(.format ~txt ~@fvals)))

(defsharp p [partial-path]
  `(do
    (import [os.path :as path])
    (path.abspath (path.expanduser ~partial-path))))

(defmacro! this-or-that [o!x y]
  `(lif ~g!x ~g!x ~y))

(defmacro color-print [&rest args]
  (setv color-map {:warn (+ Fore.YELLOW Style.BRIGHT)
                   :info Fore.CYAN
                   :error (+ Fore.RED Style.BRIGHT)
                   :normal Fore.WHITE
                   :bold (+ Fore.WHITE Style.BRIGHT)}
        n (len args)
        i 0)
  (setv out-exp '())
  (while (< i n)
    (.append out-exp
             `(print (+ ~(get color-map (nth args i)) ~(nth args (+ i 1)))
                     :end ""))
    (setv i (+ i 2)))
  (.append out-exp '(print))
  `(do ~@out-exp))

(defmacro check-args [dict query]
  "Provide True/False check for docopt args."
  (setv acc '())
  (for [q query]
    (cond [(symbol? q) (.append acc q)]
          [(string? q) (.append acc `(get ~dict ~q))]
          [(coll? q) (.append acc `(check-args ~dict ~q))]))
  acc)

(defmacro query-list [return-cond from source-list where check-cond is item]
  "SQL-ish query on list"
  `(try
    (do
     (setv item-index (.index (list (map (fn [it] ~check-cond) ~source-list)) ~item))
     ((fn [it] ~return-cond) (nth ~source-list item-index)))
    (except [ValueError] False)))

(defmacro separate [predicate source-list]
  "Separate items depending on whether they satisfy the predicate.
First list is of True items, second is of False."
  `(do
    (setv true-items []
          false-items [])
    (list
     (map (fn [x] (if (~predicate x)
                    (.append true-items x)
                    (.append false-items x))) ~source-list))
    [true-items false-items]))

(defmacro ++ [expr]
  `(+= ~expr 1))

(defmacro -- [expr]
  `(-= ~expr 1))

(defmacro thread-run [expr]
  "Start the expression in a new thread"
  `(do
    (import [threading [Thread]])
    (.start (Thread :target (fn [] ~expr)))))
