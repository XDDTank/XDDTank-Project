// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.RankViewItem

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import worldboss.player.RankingPersonInfo;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.DisplayUtils;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class RankViewItem extends Sprite implements Disposeable 
    {

        private var _txtName:FilterFrameText;
        private var _vipName:GradientText;
        private var _ranking:FilterFrameText;
        private var _num:int;
        private var _personInfo:RankingPersonInfo;
        private var _topThreeRink:ScaleFrameImage;
        private var _ranknamePos:Point;
        private var _nameTip:HeroTouchItem;

        public function RankViewItem(_arg_1:int, _arg_2:RankingPersonInfo)
        {
            this._num = _arg_1;
            this._personInfo = _arg_2;
            this._init();
        }

        private function _init():void
        {
            this._txtName = ComponentFactory.Instance.creat("toffilist.listItemNameText1");
            addChild(this._txtName);
            if (this._num <= 3)
            {
                this._topThreeRink = ComponentFactory.Instance.creat("worldboss.topThreeRink");
                addChild(this._topThreeRink);
                this._topThreeRink.setFrame(this._num);
            }
            else
            {
                this._ranking = ComponentFactory.Instance.creat("worldBoss.ranking.rank");
                addChild(this._ranking);
            };
            if (this._personInfo == null)
            {
                return;
            };
            this._intEvent();
            this._ranknamePos = ComponentFactory.Instance.creatCustomObject("worldboss.awardview.ranknamePos");
            DisplayUtils.setDisplayPos(this._txtName, this._ranknamePos);
            this._txtName.text = this._personInfo.nickName;
            if (this._personInfo.isVip)
            {
                this._txtName.visible = false;
                this._vipName = ComponentFactory.Instance.creatComponentByStylename("vipBossName");
                this._vipName.x = this._txtName.x;
                this._vipName.y = this._txtName.y;
                this._vipName.text = this._txtName.text;
                addChild(this._vipName);
            };
            this.setValue();
        }

        private function _intEvent():void
        {
            addEventListener(MouseEvent.CLICK, this._onItemClick);
        }

        private function _removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this._onItemClick);
        }

        public function _onItemClick(_arg_1:MouseEvent):void
        {
            var _local_3:Point;
            if (this._nameTip == null)
            {
                this._nameTip = ComponentFactory.Instance.creatCustomObject("worldBoss.nameText");
            };
            this._nameTip.playerName = this._personInfo.nickName;
            this._nameTip.id = this._personInfo.userId;
            var _local_2:String = this._txtName.text;
            _local_3 = this.localToGlobal(new Point(mouseX, mouseY));
            this._nameTip.x = _local_3.x;
            this._nameTip.y = _local_3.y;
            this._nameTip.setVisible = true;
        }

        private function setValue():void
        {
            this._txtName.text = this._personInfo.nickName;
            if (this._ranking)
            {
                this._ranking.text = (this._num.toString() + "th");
            };
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                this.parent.removeChild(this);
            };
            this._removeEvent();
            this._txtName = null;
            this._ranking = null;
            this._vipName = null;
        }


    }
}//package worldboss.view

