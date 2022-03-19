// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//feedback.FeedbackManager

package feedback
{
    import flash.events.EventDispatcher;
    import feedback.data.FeedbackInfo;
    import road7th.data.DictionaryData;
    import feedback.view.FeedbackSubmitFrame;
    import feedback.view.FeedbackReplyFrame;
    import road7th.data.DictionaryEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.PathManager;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import ddt.manager.PlayerManager;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import feedback.analyze.LoadFeedbackReplyAnalyzer;
    import road7th.utils.DateUtils;
    import road7th.comm.PackageIn;
    import feedback.data.FeedbackReplyInfo;
    import ddt.view.DailyButtunBar;
    import ddt.manager.TimeManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.net.URLRequestMethod;
    import com.pickgliss.utils.MD5;

    public class FeedbackManager extends EventDispatcher 
    {

        private static var _instance:FeedbackManager;

        private var _feedbackInfo:FeedbackInfo;
        private var _feedbackTime:Date;
        private var _currentTime:Date;
        private var _currentOpenInt:int;
        private var _feedbackReplyData:DictionaryData;
        private var _isReply:Boolean;
        private var _feedbackSubmitFrame:FeedbackSubmitFrame;
        private var _feedbackReplyFrame:FeedbackReplyFrame;
        private var _isSubmitTime:Boolean;
        private var _removeFeedbackInfoId:String;


        public static function get instance():FeedbackManager
        {
            if (_instance == null)
            {
                _instance = new (FeedbackManager)();
            };
            return (_instance);
        }


        public function get feedbackInfo():FeedbackInfo
        {
            if ((!(this._feedbackInfo)))
            {
                this._feedbackInfo = new FeedbackInfo();
            };
            return (this._feedbackInfo);
        }

        public function get feedbackReplyData():DictionaryData
        {
            return (this._feedbackReplyData);
        }

        public function set feedbackReplyData(_arg_1:DictionaryData):void
        {
            if (this._feedbackReplyData)
            {
                this._feedbackReplyData.removeEventListener(DictionaryEvent.ADD, this.feedbackReplyDataAdd);
                this._feedbackReplyData.removeEventListener(DictionaryEvent.REMOVE, this.feedbackReplyDataRemove);
            };
            this._feedbackReplyData = _arg_1;
            this._feedbackReplyData.addEventListener(DictionaryEvent.ADD, this.feedbackReplyDataAdd);
            this._feedbackReplyData.addEventListener(DictionaryEvent.REMOVE, this.feedbackReplyDataRemove);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.FEEDBACK_REPLY, this.feedbackReplyBySocket);
            this.checkFeedbackReplyData();
        }

        public function setupFeedbackData(_arg_1:LoadFeedbackReplyAnalyzer):void
        {
            if (PathManager.solveFeedbackEnable())
            {
                this.feedbackReplyData = _arg_1.listData;
            };
            var _local_2:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_2["userid"] = PlayerManager.Instance.Self.ID;
            var _local_3:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("AdvanceQuestTime.ashx"), BaseLoader.REQUEST_LOADER, _local_2);
            _local_3.addEventListener(LoaderEvent.COMPLETE, this.__loaderComplete);
            LoadResourceManager.instance.startLoad(_local_3);
        }

        private function __loaderComplete(_arg_1:LoaderEvent):void
        {
            _arg_1.currentTarget.removeEventListener(LoaderEvent.COMPLETE, this.__loaderComplete);
            if (_arg_1.loader.content == 0)
            {
                return;
            };
            var _local_2:Array = String(_arg_1.loader.content).split(",");
            if (_local_2[0])
            {
                if (_local_2[0] == 0)
                {
                    this._feedbackTime = null;
                }
                else
                {
                    this._feedbackTime = DateUtils.getDateByStr(_local_2[0]);
                };
            };
            if (_local_2[1])
            {
                this._currentTime = DateUtils.getDateByStr(_local_2[1]);
            };
            if (_local_2[2])
            {
                this._currentOpenInt = Number(_local_2[2]);
            };
        }

        private function feedbackReplyBySocket(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:FeedbackReplyInfo = new FeedbackReplyInfo();
            _local_3.questionId = _local_2.readUTF();
            _local_3.replyId = _local_2.readInt();
            _local_3.occurrenceDate = _local_2.readUTF();
            _local_3.questionTitle = _local_2.readUTF();
            _local_3.questionContent = _local_2.readUTF();
            _local_3.replyContent = _local_2.readUTF();
            _local_3.stopReply = _local_2.readUTF();
            this._feedbackReplyData.add(((_local_3.questionId + "_") + _local_3.replyId), _local_3);
            this.stopReplyEvt(_local_3.stopReply);
        }

        private function stopReplyEvt(_arg_1:String):void
        {
            var _local_2:Object = new Object();
            _local_2.stopReply = _arg_1;
            var _local_3:FeedbackEvent = new FeedbackEvent(FeedbackEvent.FEEDBACK_StopReply, _local_2);
            dispatchEvent(_local_3);
        }

        private function feedbackReplyDataAdd(_arg_1:DictionaryEvent):void
        {
            this.checkFeedbackReplyData();
        }

        private function feedbackReplyDataRemove(_arg_1:DictionaryEvent):void
        {
            this.checkFeedbackReplyData();
        }

        private function checkFeedbackReplyData():void
        {
            if (this._feedbackReplyData.length <= 0)
            {
                this._isReply = false;
                DailyButtunBar.Insance.setComplainGlow(false);
            }
            else
            {
                this._isReply = true;
                DailyButtunBar.Insance.setComplainGlow(true);
            };
        }

        public function examineTime():Boolean
        {
            var _local_1:Date = TimeManager.Instance.Now();
            if ((!(this._feedbackTime)))
            {
                return (true);
            };
            if ((_local_1.time - this._feedbackTime.time) >= ((1000 * 60) * 35))
            {
                return (true);
            };
            return (false);
        }

        public function show():void
        {
            if ((!(this._isReply)))
            {
                if (this._currentOpenInt >= 5)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.MaxReferTimes"));
                    return;
                };
                if (((!(this._currentTime)) && (!(this._feedbackTime))))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("BaseStateCreator.LoadingTip"));
                    return;
                };
                if (this.examineTime())
                {
                    this.openFeedbackSubmitView();
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.SystemsAnalysis"));
                };
            }
            else
            {
                this.openFeedbackReplyView();
            };
        }

        private function openFeedbackSubmitView():void
        {
            if ((!(this._feedbackSubmitFrame)))
            {
                this._feedbackSubmitFrame = ComponentFactory.Instance.creatComponentByStylename("feedback.feedbackSubmitFrame");
                this._feedbackSubmitFrame.show();
                return;
            };
            this.closeFrame();
        }

        private function openFeedbackReplyView():void
        {
            if ((!(this._feedbackReplyFrame)))
            {
                this._feedbackReplyFrame = ComponentFactory.Instance.creatComponentByStylename("feedback.feedbackReplyFrame");
                this._feedbackReplyFrame.show();
                this._feedbackReplyFrame.setup((this._feedbackReplyData.list[0] as FeedbackReplyInfo));
                return;
            };
            this.closeFrame();
        }

        public function closeFrame():void
        {
            this._feedbackInfo = null;
            if (this._feedbackSubmitFrame)
            {
                this._feedbackSubmitFrame.dispose();
                this._feedbackSubmitFrame = null;
            };
            if (this._feedbackReplyFrame)
            {
                this._feedbackReplyFrame.dispose();
                this._feedbackReplyFrame = null;
            };
        }

        public function quickReport(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            var _local_4:FeedbackInfo = new FeedbackInfo();
            _local_4.question_title = LanguageMgr.GetTranslation("quickReport.complain.lan");
            _local_4.question_content = (((((("[" + _arg_1) + "]") + "[") + _arg_2) + "]:") + _arg_3);
            _local_4.occurrence_date = DateUtils.dateFormat(new Date());
            _local_4.question_type = 9;
            _local_4.report_url = _arg_2;
            _local_4.report_user_name = _arg_2;
            FeedbackManager.instance.submitFeedbackInfo(_local_4);
        }

        public function submitFeedbackInfo(_arg_1:FeedbackInfo):void
        {
            var _local_2:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_2.user_id = PlayerManager.Instance.Self.ID.toString();
            _local_2.user_name = PlayerManager.Instance.Self.LoginName;
            _local_2.user_nick_name = PlayerManager.Instance.Self.NickName;
            _local_2.question_title = _arg_1.question_title;
            _local_2.question_content = _arg_1.question_content;
            _local_2.occurrence_date = _arg_1.occurrence_date;
            _local_2.question_type = _arg_1.question_type.toString();
            _local_2.goods_get_method = _arg_1.goods_get_method;
            _local_2.goods_get_date = _arg_1.goods_get_date;
            _local_2.charge_order_id = _arg_1.charge_order_id;
            _local_2.charge_method = _arg_1.charge_method;
            _local_2.charge_moneys = _arg_1.charge_moneys.toString();
            _local_2.activity_is_error = _arg_1.activity_is_error.toString();
            _local_2.activity_name = _arg_1.activity_name;
            _local_2.report_user_name = _arg_1.report_user_name;
            _local_2.report_url = _arg_1.report_url;
            _local_2.user_full_name = _arg_1.user_full_name;
            _local_2.user_phone = _arg_1.user_phone;
            _local_2.complaints_title = _arg_1.complaints_title;
            _local_2.complaints_source = _arg_1.complaints_source;
            var _local_3:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("AdvanceQuestion.ashx"), BaseLoader.REQUEST_LOADER, _local_2, URLRequestMethod.POST);
            _local_3.addEventListener(LoaderEvent.COMPLETE, this.__onLoadFreeBackComplete);
            LoadResourceManager.instance.startLoad(_local_3);
            this.closeFrame();
            this._isSubmitTime = true;
        }

        public function continueSubmit(_arg_1:String, _arg_2:String, _arg_3:int, _arg_4:String):void
        {
            this._removeFeedbackInfoId = ((_arg_2 + "_") + _arg_3);
            var _local_5:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_5.pass = MD5.hash((PlayerManager.Instance.Self.ID + "3kjf2jfwj93pj22jfsl11jjoe12oij"));
            _local_5.userid = PlayerManager.Instance.Self.ID;
            _local_5.nick_name = PlayerManager.Instance.Self.NickName;
            _local_5.question_id = _arg_2;
            _local_5.reply_id = _arg_3;
            _local_5.reply_content = _arg_4;
            _local_5.title = _arg_1;
            var _local_6:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("AdvanceReply.ashx"), BaseLoader.REQUEST_LOADER, _local_5, URLRequestMethod.POST);
            _local_6.addEventListener(LoaderEvent.COMPLETE, this.__onLoadFreeBackComplete);
            LoadResourceManager.instance.startLoad(_local_6);
            this.closeFrame();
        }

        public function delPosts(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:String):void
        {
            this._removeFeedbackInfoId = ((_arg_1 + "_") + _arg_2);
            var _local_5:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_5.pass = MD5.hash((PlayerManager.Instance.Self.ID + "3kjf2jfwj93pj22jfsl11jjoe12oij"));
            _local_5.userid = PlayerManager.Instance.Self.ID;
            _local_5.nick_name = PlayerManager.Instance.Self.NickName;
            _local_5.question_id = _arg_1;
            _local_5.reply_id = _arg_2;
            _local_5.appraisal_grade = _arg_3;
            _local_5.appraisal_content = _arg_4;
            var _local_6:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("AdvanceQuestionAppraisal.ashx"), BaseLoader.REQUEST_LOADER, _local_5, URLRequestMethod.POST);
            _local_6.addEventListener(LoaderEvent.COMPLETE, this.__onLoadFreeBackComplete);
            LoadResourceManager.instance.startLoad(_local_6);
            this.closeFrame();
        }

        private function __onLoadFreeBackComplete(_arg_1:LoaderEvent):void
        {
            if (_arg_1.loader.content == 1)
            {
                if (this._isSubmitTime)
                {
                    this._feedbackTime = TimeManager.Instance.Now();
                    this._currentOpenInt++;
                };
                if (this._removeFeedbackInfoId)
                {
                    this._feedbackReplyData.remove(this._removeFeedbackInfoId);
                    this._removeFeedbackInfoId = null;
                };
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.ThankReferQuestion"));
            }
            else
            {
                if (_arg_1.loader.content == -1)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.MaxReferTimes"));
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("feedback.view.SystemBusy"));
                };
            };
            this._isSubmitTime = false;
        }


    }
}//package feedback

