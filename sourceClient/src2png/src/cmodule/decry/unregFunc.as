// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.unregFunc

package cmodule.decry
{
    public function unregFunc(_arg_1:int):void
    {
        if ((_arg_1 + 1) == gstate.funcs.length)
        {
            gstate.funcs.pop();
        };
    }

}//package cmodule.decry

