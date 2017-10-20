;; General utilities

(require [hilt.macros [*]])
(import [matplotlib.pyplot :as plt])
(import [numpy :as np])

(def t True)
(def f False)

(defn plot-fn [fn range-desc]
  (let [xs (apply np.linspace range-desc)]
    (plt.plot xs (list (map fn xs)))
    (plt.show)))

(defn emap [fn series]
  "Eager map"
  (list (map fn series)))

(defn efilter [fn series]
  "Eager filter"
  (list (filter fn series)))
