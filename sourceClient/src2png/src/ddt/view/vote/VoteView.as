// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.vote.VoteView

package ddt.view.vote
{
    import com.pickgliss.ui.controls.Frame;
    import ddt.data.vote.VoteQuestionInfo;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import ddt.view.bossbox.BoxAwardsCell;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.ItemManager;
    import ddt.manager.VoteManager;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.utils.ObjectUtils;

    public class VoteView extends Frame 
    {

        public static var OK_CLICK:String = "Ok_click";
        public static var VOTEVIEW_CLOSE:String = "voteView_close";
        private static var CELL_1_GOODS:int = 11904;
        private static var CELL_2_GOODS:int = 11032;
        private static var TWOLINEHEIGHT:int = 31;
        private static var questionBGHeight_2line:int = 188;
        private static var questionBGY_2line:int = 143;
        private static var questionContentY_2line:int = 158;

        private var _voteInfo:VoteQuestionInfo;
        private var _choseAnswerID:int;
        private var _itemArr:Array;
        private var _answerIDArr:Array;
        private var _answerGroup:SelectedButtonGroup;
        private var _okBtn:TextButton;
        private var _questionBG:ScaleBitmapImage;
        private var _answerBG:ScaleBitmapImage;
        private var _questionContent:FilterFrameText;
        private var _voteProgress:FilterFrameText;
        private var _awardBG:ScaleBitmapImage;
        private var _awardWord:Bitmap;
        private var _cell1:BoxAwardsCell;
        private var _cell2:BoxAwardsCell;
        private var _bg:ScaleBitmapImage;
        private var container:VBox;
        private var panel:ScrollPanel;

        public function VoteView()
        {
            this.addEvent();
        }

        public function get choseAnswerID():int
        {
            return (this._choseAnswerID);
        }

        override protected function init():void
        {
            super.init();
            this._itemArr = new Array();
            escEnable = true;
            titleText = LanguageMgr.GetTranslation("ddt.view.vote.title");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("vote.VoteView.bg");
            this._answerBG = ComponentFactory.Instance.creatComponentByStylename("vote.answerBG");
            this._questionContent = ComponentFactory.Instance.creat("vote.questionContent");
            this._voteProgress = ComponentFactory.Instance.creat("vote.progress");
            this._okBtn = ComponentFactory.Instance.creatComponentByStylename("vote.okBtn");
            this._awardBG = ComponentFactory.Instance.creatComponentByStylename("vote.awardBG");
            this._awardWord = ComponentFactory.Instance.creatBitmap("asset.vote.awardWord");
            this._cell1 = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
            this._cell2 = ComponentFactory.Instance.creatCustomObject("bossbox.BoxAwardsCell");
            this._cell1.info = ItemManager.Instance.getTemplateById(parseInt(VoteManager.Instance.awardArr[0]));
            this._cell2.info = ItemManager.Instance.getTemplateById(parseInt(VoteManager.Instance.awardArr[1]));
            this._cell1.count = 1;
            this._cell2.count = 1;
            this.container = ComponentFactory.Instance.creatComponentByStylename("vote.voteanswerPanelView.vbox");
            this.panel = ComponentFactory.Instance.creatComponentByStylename("vote.vote.VoteanswerPanel");
            this.panel.setView(this.container);
            addToContent(this._bg);
            addToContent(this._answerBG);
            addToContent(this._questionContent);
            addToContent(this._voteProgress);
            addToContent(this._awardBG);
            addToContent(this._awardWord);
            addToContent(this._cell1);
            addToContent(this._cell2);
            addToContent(this._okBtn);
            addToContent(this.panel);
            PositionUtils.setPos(this._cell1, "bossbox.BoxAwardsCell.pos1");
            PositionUtils.setPos(this._cell2, "bossbox.BoxAwardsCell.pos2");
            this._okBtn.text = LanguageMgr.GetTranslation("ok");
        }

        public function set info(_arg_1:VoteQuestionInfo):void
        {
            this._voteInfo = _arg_1;
            this.update();
        }

        private function update():void
        {
            var _local_2:String;
            var _local_3:SelectedCheckButton;
            this.clear();
            this._voteProgress.text = ((("进度" + VoteManager.Instance.count) + "/") + VoteManager.Instance.questionLength);
            this._answerGroup = new SelectedButtonGroup();
            this._itemArr = new Array();
            this._answerIDArr = new Array();
            var _local_1:int;
            this._questionContent.text = ("    " + this._voteInfo.question);
            for (_local_2 in this._voteInfo.answer)
            {
                _local_1++;
                _local_3 = ComponentFactory.Instance.creatComponentByStylename("vote.answer.selectedBtn");
                _local_3.text = ((_local_1 + ". ") + this._voteInfo.answer[_local_2]);
                this.container.addChild(_local_3);
                this._answerGroup.addSelectItem(_local_3);
                _local_3.addEventListener(MouseEvent.CLICK, this.__playSound);
                _local_3.x = 10;
                this._itemArr.push(_local_3);
                this._answerIDArr.push(_local_2);
            };
            this.panel.invalidateViewport();
            if (this._questionContent.textHeight < TWOLINEHEIGHT)
            {
                this._questionContent.y = (questionContentY_2line + 4);
            }
            else
            {
                this._questionContent.y = (questionContentY_2line - 16);
            };
        }

        private function __playSound(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
        }

        private function clear():void
        {
            this._questionContent.text = "";
            this._voteProgress.text = "";
            if (this._answerGroup)
            {
                this._answerGroup.dispose();
            };
            this._answerGroup = null;
            var _local_1:int;
            while (_local_1 < this._itemArr.length)
            {
                this._itemArr[_local_1].removeEventListener(MouseEvent.CLICK, this.__playSound);
                this._itemArr[_local_1].dispose();
                this._itemArr[_local_1] = null;
                _local_1++;
            };
            this._itemArr = null;
            this._answerIDArr = null;
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._okBtn.addEventListener(MouseEvent.CLICK, this.__clickHandler);
        }

        private function __clickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:Boolean;
            var _local_3:int;
            while (_local_3 < this._itemArr.length)
            {
                if ((this._itemArr[_local_3] as SelectedCheckButton).selected)
                {
                    _local_2 = true;
                    break;
                };
                _local_3++;
            };
            if ((!(_local_2)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.view.vote.choseOne"));
                return;
            };
            dispatchEvent(new Event(OK_CLICK));
        }

        public function get selectAnswer():String
        {
            var _local_1:String = "";
            var _local_2:int;
            while (_local_2 < this._itemArr.length)
            {
                if ((this._itemArr[_local_2] as SelectedCheckButton).selected)
                {
                    _local_1 = ((_local_1 + this._answerIDArr[_local_2]) + ",");
                };
                _local_2++;
            };
            return (_local_1);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._okBtn.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    this.dispose();
                    dispatchEvent(new Event(VOTEVIEW_CLOSE));
                    return;
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            this.clear();
            super.dispose();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._answerBG)
            {
                ObjectUtils.disposeObject(this._answerBG);
            };
            this._answerBG = null;
            if (this._answerGroup)
            {
                ObjectUtils.disposeObject(this._answerGroup);
            };
            this._answerGroup = null;
            if (this._okBtn)
            {
                ObjectUtils.disposeObject(this._okBtn);
            };
            this._okBtn = null;
            if (this._questionContent)
            {
                ObjectUtils.disposeObject(this._questionContent);
            };
            this._questionContent = null;
            if (this._voteProgress)
            {
                ObjectUtils.disposeObject(this._voteProgress);
            };
            this._voteProgress = null;
            if (this._awardBG)
            {
                ObjectUtils.disposeObject(this._awardBG);
            };
            this._awardBG = null;
            if (this._awardWord)
            {
                ObjectUtils.disposeObject(this._awardWord);
            };
            this._awardWord = null;
            if (this._cell1)
            {
                this._cell1.dispose();
            };
            this._cell1 = null;
            if (this._cell2)
            {
                this._cell2.dispose();
            };
            this._cell2 = null;
            this._itemArr = null;
            this._answerIDArr = null;
            this._voteInfo = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package ddt.view.vote

