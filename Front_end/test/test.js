// $(function() {
//     const total = 0; // 0으로 그냥 넣어도 되요

//     const listSize = <%= list.size() %>; // listSize 가져오기
//     const prodPrice = $('.prodPrice'); // table td에 있는 값들로 추측
//     // prodPrice는 list의 크기와 같을거 같아서 그냥 반복문 뺏어요

//     for (let i = 0; i < listSize; i++) {
//         // chk가 true인 경우만
//         if ($('.chk')[i].checked == true) {
//             // 그 위치에 있는 prodPrice값을 더하기
//             total += Number(prodPrice[i].text()); // input이시면 val로 수정

//             // 이 방법이 아니면
//             //total += $($('.chk')[i]).parent().children().find('.prodPrice').text();
//             // 이렇게 체크가 있는 곳 기준으로 부모로 올라갓다 자식으로 내려가서
//             // .prodPrice를 찾을 수도 있을거 같아요
//             // 이건 좀더 구조를 알아야 확실할거 같아요 -> 테스트 필요
//         }
//     }

//     // 반복문마다 넣을 필요는 없을거 같아요
//     $('#prodSum').val(total); // 이건 반복문 다돌고나서 total을 넣어줘야할 거 같아요
// });