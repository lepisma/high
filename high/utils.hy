;; General utilities

(require [high.macros [*]])
(import [matplotlib.pyplot :as plt])
(import [numpy :as np])
(import [os [path]])

(def t True)
(def f False)

(defn ensure-file [file-path &optional [default-data ""]]
  "Create file if not exists with default-data and return path."
  (setv full-path #pfile-path)
  (ensure-dir (path.dirname full-path))

  (if (not (path.exists full-path))
      (with [f (open full-path "w")]
        (f.write default-data)))
  full-path)

(defn ensure-dir [dir-path]
  "Create directory if not exists and return path."
  (setv full-path #pdir-path)
  (if (not (path.exists full-path))
      (os.makedirs full-path))
  full-path)

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
