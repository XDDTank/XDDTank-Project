// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.VoteManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import ddt.view.vote.VoteView;
    import flash.utils.Dictionary;
    import ddt.data.vote.VoteQuestionInfo;
    import flash.events.Event;
    import ddt.data.analyze.VoteInfoAnalyzer;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import flash.net.URLVariables;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.data.analyze.VoteSubmitResultAnalyzer;

    public class VoteManager extends EventDispatcher 
    {

        public static var LOAD_COMPLETED:String = "loadCompleted";
        private static var vote:VoteManager;

        public var loadOver:Boolean = false;
        public var showVote:Boolean = true;
        public var count:int = 0;
        public var questionLength:int = 0;
        public var awardArr:Array;
        private var voteView:VoteView;
        private var list:Dictionary;
        private var firstQuestionID:String;
        private var completeMessage:String;
        private var voteId:String;
        private var allAnswer:String = "";
        private var nowVoteQuestionInfo:VoteQuestionInfo;


        public static function get Instance():VoteManager
        {
            if (vote == null)
            {
                vote = new (VoteManager)();
            };
            return (vote);
        }


        public function loadCompleted(_arg_1:VoteInfoAnalyzer):void
        {
            this.loadOver = true;
            this.list = _arg_1.list;
            this.voteId = _arg_1.voteId;
            this.firstQuestionID = _arg_1.firstQuestionID;
            this.completeMessage = _arg_1.completeMessage;
            this.questionLength = _arg_1.questionLength;
            this.awardArr = _arg_1.awardArr;
            dispatchEvent(new Event(LOAD_COMPLETED));
        }

        public function openVote():void
        {
            this.voteView = ComponentFactory.Instance.creatComponentByStylename("vote.VoteView");
            this.voteView.addEventListener(VoteView.OK_CLICK, this.__chosed);
            this.voteView.addEventListener(VoteView.VOTEVIEW_CLOSE, this.__voteViewCLose);
            if (SharedManager.Instance.voteData["userId"] == PlayerManager.Instance.Self.ID)
            {
                this.count = (SharedManager.Instance.voteData["voteProgress"] - 1);
                this.nextQuetion(SharedManager.Instance.voteData["voteQuestionID"]);
                this.allAnswer = SharedManager.Instance.voteData["voteAnswer"];
            }
            else
            {
                this.nextQuetion(this.firstQuestionID);
            };
        }

        private function __chosed(_arg_1:Event):void
        {
            this.allAnswer = (this.allAnswer + this.voteView.selectAnswer);
            this.nextQuetion(this.nowVoteQuestionInfo.nextQuestionID);
        }

        private function nextQuetion(_arg_1:String):void
        {
            this.count++;
            if (_arg_1 != "0")
            {
                this.voteView.visible = false;
                this.nowVoteQuestionInfo = this.list[_arg_1];
                this.voteView.info = this.nowVoteQuestionInfo;
                this.voteView.visible = true;
                LayerManager.Instance.addToLayer(this.voteView, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            }
            else
            {
                this.closeVote();
            };
        }

        public function closeVote():void
        {
            this.loadOver = false;
            this.showVote = false;
            this.voteView.removeEventListener(VoteView.OK_CLICK, this.__chosed);
            this.voteView.dispose();
            this.sendToServer();
        }

        private function sendToServer():void
        {
            var _local_1:URLVariables = new URLVariables();
            _local_1["userId"] = PlayerManager.Instance.Self.ID;
            _local_1["voteId"] = this.voteId;
            _local_1["answerContent"] = this.allAnswer;
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("VoteSubmitResult.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.analyzer = new VoteSubmitResultAnalyzer(this.getResult);
            LoadResourceManager.instance.startLoad(_local_2);
        }

        private function getResult(_arg_1:VoteSubmitResultAnalyzer):void
        {
            if (_arg_1.result == 1)
            {
                MessageTipManager.getInstance().show(this.completeMessage);
            }
            else
            {
                MessageTipManager.getInstance().show("投票失败!");
            };
        }

        private function __voteViewCLose(_arg_1:Event):void
        {
            this.loadOver = false;
            this.showVote = false;
            SharedManager.Instance.voteData["voteAnswer"] = this.allAnswer;
            SharedManager.Instance.voteData["voteProgress"] = this.count;
            SharedManager.Instance.voteData["voteQuestionID"] = this.nowVoteQuestionInfo.questionID;
            SharedManager.Instance.voteData["userId"] = PlayerManager.Instance.Self.ID;
            SharedManager.Instance.save();
        }


    }
}//package ddt.manager

