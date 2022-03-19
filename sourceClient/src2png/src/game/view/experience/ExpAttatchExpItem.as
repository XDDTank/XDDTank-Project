// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.experience.ExpAttatchExpItem

package game.view.experience
{
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;

    public class ExpAttatchExpItem extends ExpFightExpItem 
    {

        public function ExpAttatchExpItem(_arg_1:Array)
        {
            super(_arg_1);
        }

        override protected function init():void
        {
            _itemType = ExpTypeTxt.ATTATCH_EXP;
            PositionUtils.setPos(this, "experience.AttatchExpItemPos");
            _bg = ComponentFactory.Instance.creatBitmap("asset.experience.attachExpItemBg");
            _titleBitmap = ComponentFactory.Instance.creatBitmap("asset.experience.attachExpItemTitle");
            addChild(_bg);
            addChild(_titleBitmap);
        }

        override protected function createNumTxt():void
        {
            _numTxt = new ExpCountingTxt("experience.expCountTxt1", "experience.expTxtFilter_1,experience.expTxtFilter_2");
            _numTxt.addEventListener(Event.CHANGE, __onTextChange);
            addChild(_numTxt);
        }


    }
}//package game.view.experience

