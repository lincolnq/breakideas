; Blog tool example.  20 Jan 08, rev 21 May 09.

; To run:
; arc> (load "blog.arc")
; arc> (bsv)
; go to http://localhost:8080/blog

(= postdir* "arc/posts/"  maxid* 0  posts* (table))

(= blogtitle* "Break Ideas")

(deftem post  id nil  title nil  text nil)

(def load-posts ()
  (each id (map int (dir postdir*))
    (= maxid*      (max maxid* id)
       (posts* id) (temload 'post (string postdir* id)))))

(def save-post (p) (save-table p (string postdir* p!id)))

(def post (id) (posts* (errsafe:int id)))

(mac blogpage body
  `(whitepage 
     (center
       (widtable 600 
         (tag b (link blogtitle* "blog"))
         (br 3)
         ,@body
         (br 3)
         (link "archive")))))

(defop viewpost req (blogop post-page req))

(def blogop (f req)
  (aif (post (arg req "id")) 
       (f (get-user req) it) 
       (blogpage (pr "No such post."))))

(def permalink (p) (string "viewpost?id=" p!id))

(def post-page (user p) (blogpage (display-post user p)))

(def display-post (user p)
  (tag b (link p!title (permalink p)))
  (br2)
  (pr p!text))

(defopl newpost req
  (whitepage
    (aform [let u (get-user _)
             (post-page u (addpost u (arg _ "t") (arg _ "b")))]
      (tab (row "title" (input "t" "" 60))
           (row "text"  (textarea "b" 10 80))
           (row ""      (submit))))))

(def addpost (user title text)
  (let p (inst 'post 'id (++ maxid*) 'title title 'text text)
    (save-post p)
    (= (posts* p!id) p)))

(defopl editpost req (blogop edit-page req))

(def edit-page (user p)
  (whitepage
    (vars-form user
               `((string title ,p!title t t) (text text ,p!text t t))
               (fn (name val) (= (p name) val))
               (fn () (save-post p)
                      (post-page user p)))))

(defop archive req
  (blogpage
    (tag ul
      (each p (map post (rev (range 1 maxid*)))
        (tag li (link p!title (permalink p)))))))

(defop blog req
  (let user (get-user req)
    (blogpage
      (tag (font size 5) (pr "Stop what you're doing."))
      (br 2)
      (pr "Take an eight minute break. Just generate ideas.")
      (br 2)
      (tag (font size 2) (pr "(You probably need a wrist break anyway. Push your chair away from your computer. Come on, eight minutes won't kill you! You might even think of something nobody's thought of before.)"))
      (br 3)
      (pr "Here's your inspiration:")
      (br 3)
      (with (c 2 i maxid*)
       (while (and (> i 0)
                   (> i (- maxid* 100))
                   (> c 0))
        (= i (- i 1))
        (aif (or (< i c) (< (rand) 0.1))
         (awhen (posts* (- maxid* i))
          (display-post user it)
          (= c (- c 1))
          (br 3)))))
      (br 3)
      (pr "Go away for ")
      (js-timer (* 60 8))
      (pr "!")
      (br 2)
      (link "Back already? Now share your ideas!" "newpost"))))

(def js-timer (secs)
    (tag (span id "thetime") (pr "a few minutes"))
    (pr "<script type='text/javascript'>
var remain = " secs ";
var timeoutid = setInterval(cd, 1000);
function cd() {
    remain -= 1;
    document.getElementById('thetime').innerHTML = Math.floor(remain / 60) + ':' + (remain % 60);
    if(!remain) {
        clearTimeout(timeoutid);
    }
}
</script>"))

(def bsv ()
  (ensure-dir postdir*)
  (load-posts)
  (asv))


