; Blog tool example.  20 Jan 08, rev 21 May 09.

; To run:
; arc> (load "blog.arc")
; arc> (bsv)
; go to http://localhost:8080/blog

(= postdir* "arc/posts/"  
   maxid* 0  
   posts* (table) 
   userdir* "arc/users/"
   user-profiles* (table))

(= blogtitle* "Break Ideas")

(deftem post  id nil  title nil  text nil  user nil)


(deftem profile
  name       nil
  created    (seconds)
  about      nil
)


(def load-posts ()
  (each id (map int (dir postdir*))
    (= maxid*      (max maxid* id)
       (posts* id) (temload 'post (string postdir* id)))))


(def load-users ()
  (each uid (dir userdir*)
    (= (user-profiles* uid) (temload 'profile (string userdir* uid)))))

(def save-post (p) (save-table p (string postdir* p!id)))
(def save-user (profile) (save-table profile (string userdir* profile!id)))

(def post (id) (posts* (errsafe:int id)))
(def profile (uid) (user-profiles* uid))

(mac blogpage (userx . body)
  (w/uniq user
   `(let ,user ,userx
     (tag html
      (tag head
        (tag (link  rel "stylesheet"  href "http://techhouse.org/~lincoln/a.css"  type "text/css"  media "screen")))
      (tag body
       (divclass "blogpage"
        (divclass "top"
          (divclass "topleft"
            (tag h1 (link blogtitle* "blog")))
          (divclass "topright" 
            (divclass "login"
              (if ,user
                (link "logout" "/logout")
                (onlink "login" 
                  (login-page 'both nil (fn (u ip) (link "logged in" "/blog"))))))))
        (divclass "body" ,@body)
        (divclass "bottom" (w/bars
            (link "idea archive" "/archive")
            (link "site by lincolnq" "http://techhouse.org/~lincoln/")
            (link "background by xbxg32000" "http://en.wikipedia.org/wiki/File:Newman_Library_2.jpg")))))))))

(defop viewpost req (blogop post-page req))

(def blogop (f req)
  (aif (post (arg req "id")) 
       (f (get-user req) it) 
       (blogpage (get-user req) (pr "No such post."))))

(def permalink (p) (string "viewpost?id=" p!id))
(def userlink (username) (string "user?id=" username))

(defop user req
  (iflet target-uid (arg req "id")
     (if (user-exists target-uid)
         (user-page (get-user req) target-uid)
         (blogpage (get-user req) (pr "No such user.")))))
     

(def post-page (user p) (blogpage user (display-post user p)))

(def user-page (user target-user)
  (let prof (or (profile target-user) (addprofile target-user))
    (blogpage user
      (tag b (pr target-user))
      (br2)
      (if (is user target-user)
        (vars-form target-user 
                   `((text about ,prof!about t t))
                   (fn (name val) (= (prof name) val))
                   (fn () (save-user prof)
                          (user-page user target-user)))
        ; else
        (do
          (pr "About:")
          (br)
          (pr (or prof!about "")))))))

(def display-post (user p)
  (tag b (link p!title (permalink p))) 
  (spanclass "byline"
    (pr " by ")
    (link p!user (userlink p!user)))
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
  (let p (inst 'post 'id (++ maxid*) 'title title 'text text 'user user)
    (save-post p)
    (= (posts* p!id) p)))

(def addprofile (userid)
  (let u (inst 'profile 'id userid)
    (save-user u)
    (= (user-profiles* userid) u)))

(defopl editpost req (blogop edit-page req))

(def edit-page (user p)
  (whitepage
    (vars-form user
               `((string title ,p!title t t) (text text ,p!text t t))
               (fn (name val) (= (p name) val))
               (fn () (save-post p)
                      (post-page user p)))))

(defop archive req
  (blogpage (get-user req)
    (tag ul
      (each p (map post (rev (range 1 maxid*)))
        (tag li 
          (link p!title (permalink p))
          (spanclass "byline"
            (pr " by ")
            (link p!user (userlink p!user))))))))

(defop blog req 
  (let user (get-user req)
    (blogpage user
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

(defop "a.css" req
  (pr "
"))

(def bsv ()
  (ensure-dir postdir*)
  (load-posts)
  (asv))


