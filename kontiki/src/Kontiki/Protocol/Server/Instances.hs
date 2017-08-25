{-# LANGUAGE TypeFamilies #-}

{-# OPTIONS_GHC -fno-warn-orphans #-}

module Kontiki.Protocol.Server.Instances () where

import Control.Lens (lens)

import Test.QuickCheck (Arbitrary, arbitrary)
import Data.Text.Lazy (fromStrict)
import Data.Text.Arbitrary ()

import qualified Kontiki.Raft.Classes.RPC as RPC
import qualified Kontiki.Raft.Classes.RPC.RequestVoteRequest as RVReq
import qualified Kontiki.Raft.Classes.RPC.RequestVoteResponse as RVResp

import Kontiki.Types (Term(Term, getTerm), Index(Index, getIndex), Node(Node, getNode))
import Kontiki.Protocol.Server (RequestVoteRequest(RequestVoteRequest), RequestVoteResponse(RequestVoteResponse))
import qualified Kontiki.Protocol.Server as S

instance RPC.HasTerm RequestVoteRequest where
    type Term RequestVoteRequest = Term

    term = lens (Term . S.requestVoteRequestTerm) (\r t -> r { S.requestVoteRequestTerm = getTerm t })

instance RVReq.RequestVoteRequest RequestVoteRequest where
    type Node RequestVoteRequest = Node
    type Index RequestVoteRequest = Index

    candidateId = lens (Node . S.requestVoteRequestCandidateId) (\r n -> r { S.requestVoteRequestCandidateId = getNode n })
    lastLogIndex = lens (Index . S.requestVoteRequestLastLogIndex) (\r i -> r { S.requestVoteRequestLastLogIndex = getIndex i })
    lastLogTerm = lens (Term . S.requestVoteRequestLastLogTerm) (\r t -> r { S.requestVoteRequestLastLogTerm = getTerm t })

instance Arbitrary RequestVoteRequest where
    arbitrary = RequestVoteRequest <$> arbitrary
                                   <*> (fromStrict <$> arbitrary)
                                   <*> arbitrary
                                   <*> arbitrary


instance RPC.HasTerm RequestVoteResponse where
    type Term RequestVoteResponse = Term

    term = lens (Term . S.requestVoteResponseTerm) (\r t -> r { S.requestVoteResponseTerm = getTerm t })

instance RVResp.RequestVoteResponse RequestVoteResponse where
    voteGranted = lens S.requestVoteResponseVoteGranted (\r g -> r { S.requestVoteResponseVoteGranted = g })

instance Arbitrary RequestVoteResponse where
    arbitrary = RequestVoteResponse <$> arbitrary
                                    <*> arbitrary
