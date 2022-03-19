// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.RankingPersonInfoItem

package worldboss.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import worldboss.player.RankingPersonInfo;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class RankingPersonInfoItem extends Sprite implements Disposeable 
    {

        private var _txtName:FilterFrameText;
        private var _txtDamage:FilterFrameText;
        private var _ranking:FilterFrameText;
        private var _num:int;
        private var _personInfo:RankingPersonInfo;
        private var _bg:ScaleFrameImage;
        private var _longBg:Boolean;

        public function RankingPersonInfoItem(_arg_1:int, _arg_2:RankingPersonInfo, _arg_3:Boolean=false)
        {
            this._num = _arg_1;
            this._personInfo = _arg_2;
            this._longBg = _arg_3;
            this._init();
        }

        private function _init():void
        {
            if (this._longBg)
            {
                this._bg = ComponentFactory.Instance.creatComponentByStylename("worldBossAward.rankingItemBg");
            }
            else
            {
                this._bg = ComponentFactory.Instance.creatComponentByStylename("worldboss.RankingItem.bg");
            };
            addChild(this._bg);
            if (((this._num % 2) == 0))
            {
                this._bg.setFrame(1);
            }
            else
            {
                this._bg.setFrame(2);
            };
            this._txtName = ComponentFactory.Instance.creat("worldBoss.ranking.name");
            addChild(this._txtName);
            this._txtDamage = ComponentFactory.Instance.creat("worldBoss.ranking.damage");
            addChild(this._txtDamage);
            this._ranking = ComponentFactory.Instance.creat("worldBoss.ranking.num");
            addChild(this._ranking);
            this.setValue();
        }

        private function setValue():void
        {
            this._txtName.text = this._personInfo.name;
            this._txtDamage.text = this._personInfo.damage.toString();
            this._ranking.text = this._num.toString();
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                this.parent.removeChild(this);
            };
            this._bg = null;
            this._txtName = null;
            this._txtDamage = null;
            this._ranking = null;
        }


    }
}//package worldboss.view

