#
# Front-end to bring some sanity to the litany of tools and switches
# in calling the sample application from the command line.
#
# This file covers off driving the API independent of where the cluster is
# running.
# Be sure to set your context appropriately for the log monitor.
#
# The intended approach to working with this makefile is to update select
# elements (body, id, IP, port, etc) as you progress through your workflow.
# Where possible, stodout outputs are tee into .out files for later review.
#


CURL=curl

# Keep all the logs out of main directory
LOG_DIR=logs

# look these up with 'make ls'
# You need to specify the container because istio injects side-car container
# into each pod.
# s1: service1; s2: service2; db: cmpt756db
PODS1=pod/cmpt756s1-0000000000-xxxxx
PODCONT=service1

#
# Specify the external IP/DNS name of your cluster here 
#
# Look up the external IP of the istio-ingressgateway LoadBalancer service
#
# $ kubectl -n istio-system get service istio-ingressgateway
#
#IGW=a344add95f74b453684bcd29d1461240-517644147.us-west-2.elb.amazonaws.com:80
#IGW=127.0.0.1
IGW=LOOK-ME-UP


# stock body & fragment for API requests
BODY_USER= { \
"fname": "Sherlock", \
"email": "sholmes@baker.org", \
"lname": "Holmes" \
}

BODY_UID= { \
    "uid": "0d2a2931-8be6-48fc-aa9e-5a0f9f536bd3" \
}

BODY_MUSIC= { \
  "Artist": "Duran Duran", \
  "SongTitle": "Rio" \
}

# this is a JWT token; the default implementation in s1/s2 doesn't check for validity.
TOKEN=Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMDI3Yzk5ZWYtM2UxMi00ZmM5LWFhYzgtMTcyZjg3N2MyZDI0IiwidGltZSI6MTYwMTA3NDY0NC44MTIxNjg2fQ.hR5Gbw5t2VMpLcj8yDz1B6tcWsWCFNiHB_KHpvQVNls
BODY_TOKEN={ \
    "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMDI3Yzk5ZWYtM2UxMi00ZmM5LWFhYzgtMTcyZjg3N2MyZDI0IiwidGltZSI6MTYwMTA3NDY0NC44MTIxNjg2fQ.hR5Gbw5t2VMpLcj8yDz1B6tcWsWCFNiHB_KHpvQVNls" \
}

# keep these ones around
USER_ID=0d2a2931-8be6-48fc-aa9e-5a0f9f536bd3
MUSIC_ID=2995bc8b-d872-4dd1-b396-93fde2f4bfff

# it's convenient to have a second set of id to test deletion (DELETE uses these id with the suffix of 2)
USER_ID2=9175a76f-7c4d-4a3e-be57-65856c6bb77e
MUSIC_ID2=8ed63e4f-3b1e-47f8-beb8-3604516e5a2d


# ----------------------------------------------------------------------------------------
# -------  Use the following to trigger your API                                   -------
# ----------------------------------------------------------------------------------------


# --- cuser: create a new user record
cuser:
	$(CURL) --location --request POST 'http://$(IGW)/api/v1/user/' \
		--header 'Content-Type: application/json' \
		--data-raw '$(BODY_USER)' | tee -a $(LOG_DIR)/cuser.out

# --- uuser: update an existing user
uuser:
	$(CURL) --location --request PUT 'http://$(IGW)/api/v1/user/$(USER_ID)' \
		--header '$(TOKEN)' --header 'Content-Type: application/json' \
		--data-raw '$(BODY_USER)' | tee -a $(LOG_DIR)/uuser.out

# --- duser: delete an existing user
duser:
	$(CURL) --location --request DELETE 'http://$(IGW)/api/v1/user/$(USER_ID2)' \
		--header '$(TOKEN)' | tee -a $(LOG_DIR)/duser.out

# --- cmusic: create a new song record
cmusic:
	$(CURL) --location --request POST 'http://$(IGW)/api/v1/music/' \
		--header '$(TOKEN)' --header 'Content-Type: application/json' \
		--data-raw '$(BODY_MUSIC)' | tee -a $(LOG_DIR)/cmusic.out

# --- rmusic: read an existing song record
rmusic:
	$(CURL) --location --request GET 'http://$(IGW)/api/v1/music/$(MUSIC_ID)' \
		--header '$(TOKEN)' | tee -a $(LOG_DIR)/rmusic.out

# --- dmusic: delete an existing song record
dmusic:
	$(CURL) --location --request DELETE 'http://$(IGW)/api/v1/music/$(MUSIC_ID2)' \
		--header '$(TOKEN)' | tee -a $(LOG_DIR)/dmusic.out


# --- apilogin: login in using the user service and retrieve a JWT token suitable for subsequent action
#               NB: the s1/s2 are incomplete and do not validate the token passed in.
apilogin:
	$(CURL) --location --request PUT 'http://$(IGW)/api/v1/user/login' \
		--header 'Content-Type: application/json' \
		--data-raw '$(BODY_UID)' | tee -a $(LOG_DIR)/apilogin.out

# --- apilogoff: log off the user service
apilogoff:
	$(CURL) --location --request PUT 'http://$(IGW)/api/v1/user/logoff' \
		--header 'Content-Type: application/json' \
		--data-raw '$(BODY_TOKEN)' | tee -a $(LOG_DIR)/apilogoff.out
