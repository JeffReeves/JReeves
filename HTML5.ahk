;
; Autocomplete for HTML5 Tags
;   Author: Jeffrey Reeves
;

#Hotstring R0 B0 C1 *
#Hotstring EndChars `n `t

::<!--::-->{left 3}
::<!DOC::TYPE html>

::<a h::
SendInput, ref="
SendInput, ^v
SendInput," target="_blank"></a>{left 4}
Return

::<abbr::></abbr>{left 7}
::<address::></address>{left 10}
::<area::>
::<article::></article>{left 10}
::<aside::></aside>{left 8}
::<audio::></audio>{left 8}

::<base::>
::<bdi::></bdi>{left 6}
::<bdo::></bdo>{left 6}
::<blockquote::></blockquote>{left 13}
::<body>::{Enter}{Enter}</body>{left 7}{Left 1}
::<br::>
::<button::></button>{left 9}

::<canvas::></canvas>{left 9}
::<caption::></caption>{left 10}
::<cite::></cite>{left 7}
::<code::></code>{left 7}
::<col>::
::<colgroup::></colgroup>{left 11}
::<command::>

::<datalist::></datalist>{left 11}
::<dd::></dd>{left 5}
::<del::></del>{left 6}
::<details::></details>{left 10}
::<dfn::></dfn>{left 6}
::<div::></div>{left 6}
::<dl::></dl>{left 5}
::<dt::></dt>{left 5}

::<em>::</em>{left 5}
::<embed::>

::<fieldset::></fieldset>{left 11}
::<figcaption::></figcaption>{left 12}
::<figure::></figure>{left 9}
::<footer::></footer>{left 9}
::<form::></form>{left 7}

::<h1::></h1>{left 5}
::<h2::></h2>{left 5}
::<h3::></h3>{left 5}
::<h4::></h4>{left 5}
::<h5::></h5>{left 5}
::<h6::></h6>{left 5}
::<head>::{Enter}{Enter}</head>{left 7}{Left 1}
::<header::></header>{left 9}
::<hgroup::></hgroup>{left 9}
::<hr::>
::<html::>{Enter}{Enter}</html>{left 7}{Left 1}

::<iframe::></iframe>{left 9}
::<img src=""::>{left 2}
::<input::>
::<ins::></ins>{left 6}

::<kdb::></kdb>{left 6}
::<keygen::>

::<label::></label>{left 8}
::<legend::></legend>{left 9}
::<li>::</li>{left 5}
::<link::>

::<main::>{Enter}</main>{left 7}{left 1}
::<map::></map>{left 6}
::<mark::></mark>{left 7}
::<menu::></menu>{left 7}
::<meta::>
::<meter::></meter>{left 8}

::<nav::></nav>{left 6}
::<noscript::></noscript>{left 10}

::<object::></object>{left 9}
::<ol::>{Enter}<li></li>{Enter}</ol>{Left 5}{left 6}
::<optgroup::></optgroup>{left 11}
::<option::></option>{left 9}
::<output::></output>{left 9}

::<p>::</p>{left 4}
::<param::>
::<pre::></pre>{left 6}
::<progress::></progress>{left 11}

::<q::></q>{left 4}

::<rp::></rp>{left 5}
::<rt::></rt>{left 5}
::<ruby::></ruby>{left 7}

::<s>::</s>{left 4}
::<samp::></samp>{left 7}
::<script::></script>{left 9}
::<section::></section>{left 10}
::<select::></select>{left 9}
::<small::></small>{left 8}
::<source::>
::<span::></span>{left 7}
::<strong::></strong>{left 9}
::<style::></style>{left 8}
::<sub::></sub>{left 6}
::<summary::></summary>{left 10}
::<sup::></sup>{left 6}

::<table::></table>{left 8}
::<tbody::></tbody>{left 8}
::<td::></td>{left 5}
::<textarea::></textarea>{left 11}
::<tfoot::></tfoot>{left 8}
::<th>::</th>{left 5}
::<thead::></thead>{left 8}
::<time::></time>{left 7}
::<title::></title>{left 8}
::<tr::></tr>{left 5}
::<track::>

::<u>::</u>{left 4}
::<ul::>{Enter}<li></li>{Enter}</ul>{Left 5}{left 6}

::<var::></var>{left 6}
::<video::></video>{left 8}

::<wbr::>
